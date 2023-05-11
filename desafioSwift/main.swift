import Foundation
import ArgumentParser

var listaNewUser = ListaTarefas(lista: [])
listaNewUser.inicializar()

func novaTarefa(){
    print("Digite o titulo: ")
    var titulo: String = ""
    if let unwrapTitulo = readLine(){
        titulo = unwrapTitulo
    }

    print("Digite a descricao: ")
    var descricao: String = ""
    if let unwrapDescricao = readLine(){
        descricao = unwrapDescricao
    }

    var status: Bool = false
    var concluida: String = ""
    while concluida.lowercased() != "y" && concluida.lowercased() != "n" {
        print("A tarefa foi concluida? (Y/n) ")
        if let teste = readLine(){
            concluida = teste
        }
        status = concluida.lowercased() == "y" ? true : false
    }


    let tarefa: Tarefa = Tarefa(titulo: titulo, descricao: descricao, concluida: status)
    listaNewUser.adicionarTarefa(novaTarefa: tarefa)
    print("A tarefa foi adicionada com sucesso.\n")
}

func editarTarefa(searchTerm: String){
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: searchTerm) {
        print("\nEscolha o index da tarefa para edicao")
        if let input = readLine(), let number = Int(input) {
            let tarefa = tupla.first(where: { element in
                element.0 == number-1
            })
            print("Digite o novo titulo: ")
            var titulo: String = ""
            if let unwrapTitulo = readLine(){
                titulo = unwrapTitulo.isEmpty ? tarefa!.1.titulo : unwrapTitulo
            }

            print("Digite a nova descricao: ")
            var descricao: String = ""
            if let unwrapDescricao = readLine(){
                descricao = unwrapDescricao.isEmpty ? tarefa!.1.titulo : unwrapDescricao
            }

            var status: Bool = false
            var concluida: String = ""
            while concluida.lowercased() != "y" && concluida.lowercased() != "n" && concluida.isEmpty{
                print("A tarefa foi concluida? (Y/n) ")
                if let teste = readLine(){
                    concluida = teste
                    concluida = teste.isEmpty ? tarefa!.1.titulo : teste
                }
                status = concluida.lowercased() == "y" ? true : false
            }


            let novatarefa: Tarefa = Tarefa(titulo: titulo, descricao: descricao, concluida: status)
            listaNewUser.editarTarefa(tarefaAntiga: tarefa!.1, novaTarefa: novatarefa)

//            listaNewUser.removerTarefa(tarefaRemovida: tarefa!.1.titulo)
        } else {
            print("Erro: a entrada não é um número válido.")
        }
    }
}

func excluirTarefa(searchTerm: String) {
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: searchTerm) {
        print("\nEscolha o index da tarefa para remover")
        if let input = readLine(), let number = Int(input) {
            let tarefa = tupla.first(where: { element in
                element.0 == number-1
            })
            print(tarefa!.1)
            listaNewUser.removerTarefa(tarefaRemovida: tarefa!.1.titulo)
        } else {
            print("Erro: a entrada não é um número válido.")
        }
    }
}

func mudarStatusTarefa(searchTerm: String){
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: searchTerm) {
        print("\nEscolha o index da tarefa para alterar o status")
        if let input = readLine(), let number = Int(input) {
            print(tupla)
            let tarefa = tupla.first(where: { element in
                element.0 == number-1
            })
            listaNewUser.alterarStatusTarefa(searchTerm: tarefa!.1.titulo)
            print(tarefa!.1.concluida ? "\nA Tarefa \(tarefa!.1.titulo) foi concluída": "\nA Tarefa \(tarefa!.1.titulo) não foi concluída")

        } else {
            print("Erro: a entrada não é um número válido.")
        }
    }
}

func executarAplicacao(){
    var running: Bool = true
    print("""

        Ola! Bem vindo a nossa aplicação!
        """)
    while(running){
        print("""
        Digite:
            new\t\t\t\t\t\t  para criar uma nova tarefa
            remove <searchTerm>\t\t  para remover uma tarefa
            edit <searchTerm>\t\t  para editar uma tarefa
            changeStatus <searchTerm> para mudar o status de uma tarefa
            search <searchTerm>\t\t  para pesquisar uma tarefa
            list\t\t\t\t\t  para listar as tarefas
            end \t\t\t\t\t  para finalizar
        """)

        if let input = readLine() {
            let components = input.split(separator: " ")
            if let command = components.first {
                let argument = components.dropFirst().joined(separator: " ")
                switch command {
                case "new":
                    novaTarefa()
                case "remove":
                    excluirTarefa(searchTerm: argument)
                case "edit":
                    editarTarefa(searchTerm: argument)
                case "changeStatus":
                    mudarStatusTarefa(searchTerm: argument)
                case "search":
                    listaNewUser.pesquisarTarefa(searchTerm: argument)
                case "list":
                    listaNewUser.listarTarefas()
                case "end":
                    listaNewUser.criarJSON()
                    running = false
                    exit(EXIT_SUCCESS)
                default:
                    print("Esse comando não existe x_x ")
                }
            } else {
                print("Nenhum input foi dado.")
            }
        }

    }

}
executarAplicacao()
