//
//  PlayerEditableSheet.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 29/08/25.
//

import SwiftUI
import SwiftData
import Kingfisher

struct PlayerEditableSheet: View {
    @Query(sort: [SortDescriptor(\PlayerInfo.name, order: .forward)]) var players: [PlayerInfo]

    @Environment(\.modelContext) private var context

    @State var userInfo: LudoUserInfo? = nil

    @State var name: String = ""

    @State var ludopediaUser: String = ""

    @State var isClosing = false

    var isActionDisabled: Bool {
        name.isEmpty || nameAlreadyExists
    }

    var nameAlreadyExists: Bool {
        switch sheetContext {
        case .addPlayer:
            players.contains(where: { $0.name == name})
        case .editPlayer(let playerInfo):
            name != playerInfo.name && players.contains(where: { $0.name == name})
        }
    }

    var sheetContext: Context

    var onAdd: ((String) -> Void)?

    var body: some View {
        VStack {
            Text(sheetContext.title)
                .padding()
                .font(.title)

            VStack {
                TextField("Name*", text: $name)
                    .padding()
                    .frame(height: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.surface)
                    }
                HStack {
                    if let userInfo, userInfo.user == ludopediaUser {
                        KFImage.url(URL(string: userInfo.thumb))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    TextField("Ludopedia ID", text: $ludopediaUser)
                        .padding()
                    if userInfo?.user == ludopediaUser {
                        Image(systemName: "checkmark.seal.fill")
                            .padding()
                    } else {
                        Image(systemName: "x.circle.fill")
                            .padding()
                    }
                }
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.surface)
                }
                if userInfo?.user != ludopediaUser && ludopediaUser.isNotEmpty {
                    LudoUserPickerView(
                        query: ludopediaUser,
                        onSelected: {
                            ludopediaUser = $0.user
                            userInfo = LudoUserInfo(id: $0.id, user: $0.user, thumb: $0.thumb)
                        })
                }
            }.padding()

            Spacer()
            if !isClosing && nameAlreadyExists {
                Text("Name already exists!")
                    .foregroundStyle(.error)
            }
            Button(sheetContext.actionButton) {
                isClosing = true
                switch sheetContext {
                case .addPlayer:
                    context.insert(PlayerInfo(name: name, ludoUser: userInfo?.createEntity()))

                case .editPlayer(let playerInfo):
                    playerInfo.name = name
                    playerInfo.ludoUser = userInfo?.createEntity()
                }
                onAdd?(name)
            }
            .disabled(isActionDisabled)
            .padding()
        }.onAppear {
            if case .editPlayer(let info) = sheetContext {
                name = info.name
                if let ludoUser = info.ludoUser {
                    ludopediaUser = ludoUser.user
                    userInfo = LudoUserInfo.fromEntity(ludoUser)
                }
            }
        }
    }

    enum Context: Identifiable {
        var id: Int {
            switch self {
            case .addPlayer:
                return 1
            case .editPlayer:
                return 2
            }
        }

        case addPlayer
        case editPlayer(PlayerInfo)

        var title: String {
            switch self {
            case .addPlayer:
                return "Add Player"
            case .editPlayer:
                return "Edit Player"
            }
        }

        var actionButton: String {
            switch self {
            case .addPlayer:
                return "Add"
            case .editPlayer:
                return "Save"
            }
        }

        var isAdding: Bool {
            switch self {
            case .addPlayer:
                return true
            case .editPlayer:
                return false
            }
        }

        var isEditing: Bool {
            switch self {
            case .addPlayer:
                return false
            case .editPlayer:
                return true
            }
        }
    }

    struct LudoUserInfo {
        var id: Int
        var user: String
        var thumb: String

        func createEntity() -> LudoUser {
            LudoUser(id: id, user: user, thumb: thumb)
        }

        static func fromEntity(_ entity: LudoUser) -> LudoUserInfo {
            .init(id: entity.id, user: entity.user, thumb: entity.thumb)
        }
    }
}

#Preview {
    PlayerEditableSheet(sheetContext: .addPlayer)
}
