//
//  Menu.swift
//  desafioSwift
//
//  Created by user on 11/05/23.
//

import Foundation

var listaNewUser = ListaTarefas(lista: [])

func formularioTarefa(tarefaToEdit: EnumeratedSequence<[Tarefa]>.Element? = nil) -> Tarefa {
    print("Digite o titulo:")
    var titulo: String = ""
    if let unwrapTitulo = readLine(){
        if tarefaToEdit != nil {
            titulo = unwrapTitulo.isEmpty ? tarefaToEdit!.1.titulo : unwrapTitulo
        } else {
            titulo = unwrapTitulo
        }
    }

    print("Digite a descricao:")
    var descricao: String = ""
    if let unwrapDescricao = readLine(){
        if tarefaToEdit != nil {
            descricao = unwrapDescricao.isEmpty ? tarefaToEdit!.1.titulo : unwrapDescricao
        } else {
            descricao = unwrapDescricao
        }
    }

    var status: Bool = false
    var concluida: String = ""
    while concluida.lowercased() != "y" && concluida.lowercased() != "n" && concluida.isEmpty {
        print("A tarefa foi concluida? (Y/n):")
        if let unwrapConcluida = readLine(){
            concluida = unwrapConcluida
            if tarefaToEdit != nil {
                concluida = unwrapConcluida.isEmpty ? tarefaToEdit!.1.titulo : unwrapConcluida
            } else {
                concluida = unwrapConcluida
            }
        }
        status = concluida.lowercased() == "y" ? true : false
    }
    let tarefa: Tarefa = Tarefa(titulo: titulo, descricao: descricao, concluida: status)
    return tarefa
}
func novaTarefa() -> Void{
    let tarefa = formularioTarefa()
    listaNewUser.adicionarTarefa(novaTarefa: tarefa)
    print("A tarefa foi adicionada com sucesso.\n")
}

func editarTarefa(searchTerm: String) -> Void{
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: searchTerm) {
        print("\nEscolha o index da tarefa para edicao:")
        if let input = readLine(), let number = Int(input) {
            let tarefa = tupla.first(where: { element in
                element.0 == number-1
            })
            let novaTarefa = formularioTarefa(tarefaToEdit: tarefa)
            listaNewUser.editarTarefa(tarefaAntiga: tarefa!.1, novaTarefa: novaTarefa)
        } else {
            print("Erro: a entrada não é um número válido.\n")
        }
    }
}

func excluirTarefa(searchTerm: String) -> Void {
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: searchTerm) {
        print("\nEscolha o index da tarefa para remover:")
        if let input = readLine(), let number = Int(input) {
            let tarefa = tupla.first(where: { element in
                element.0 == number-1
            })
            print(tarefa!.1)
            listaNewUser.removerTarefa(tarefaRemovida: tarefa!.1.titulo)
        } else {
            print("Erro: a entrada não é um número válido.\n")
        }
    }
}

func mudarStatusTarefa(searchTerm: String) -> Void{
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: searchTerm) {
        print("\nEscolha o index da tarefa para alterar o status")
        if let input = readLine(), let number = Int(input) {
            print(tupla)
            let tarefa = tupla.first(where: { element in
                element.0 == number-1
            })
            listaNewUser.alterarStatusTarefa(searchTerm: tarefa!.1.titulo)
            print(tarefa!.1.concluida ? "\nA Tarefa \(tarefa!.1.titulo) foi concluída\n": "\nA Tarefa \(tarefa!.1.titulo) não foi concluída\n")

        } else {
            print("Erro: a entrada não é um número válido.\n")
        }
    }
}

func pesquisarTarefa(searchTerm: String) -> Void{
    listaNewUser.pesquisarTarefa(searchTerm: searchTerm)
}

func help() -> Void {
    print("""
        \n
    Digite:
        nova, n\t\t\t\t\t\t  para criar uma nova tarefa
        remover, r <searchTerm>\t\t  para remover uma tarefa
        editar, e <searchTerm>\t\t  para editar uma tarefa
        mudarStatus, m <searchTerm>   para mudar o status de uma tarefa
        procurar, p <searchTerm>\t  para pesquisar uma tarefa
        listar, l \t\t\t\t\t  para listar as tarefas
        finalizar, f \t\t\t\t  para finalizar
        \n
    """)
}

func executarAplicacao(){
    listaNewUser.inicializar()
    
    var running: Bool = true
    print("""

        Ola! Bem vindo a nossa aplicação!
        """)
    print("""
    ⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣠⣤⣶⣶
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢰⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣾⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⡏⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿
    ⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠁⠀⣿
    ⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠙⠿⠿⠿⠻⠿⠿⠟⠿⠛⠉⠀⠀⠀⠀⠀⣸⣿
    ⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣴⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢰⣹⡆⠀⠀⠀⠀⠀⠀⣭⣷⠀⠀⠀⠸⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠈⠉⠀⠀⠤⠄⠀⠀⠀⠉⠁⠀⠀⠀⠀⢿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⢾⣿⣷⠀⠀⠀⠀⡠⠤⢄⠀⠀⠀⠠⣿⣿⣷⠀⢸⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⡀⠉⠀⠀⠀⠀⠀⢄⠀⢀⠀⠀⠀⠀⠉⠉⠁⠀⠀⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿
    """)
    print("UMA TODO LIST?\n\n")
    help()
    while(running){

        if let input = readLine() {
            let components = input.split(separator: " ")
            if let command = components.first {
                let argument = components.dropFirst().joined(separator: " ")
                switch command {
                case "nova", "n":
                    novaTarefa()
                case "remover", "r":
                    excluirTarefa(searchTerm: argument)
                case "editar", "e":
                    editarTarefa(searchTerm: argument)
                case "mudarStatus", "m":
                    mudarStatusTarefa(searchTerm: argument)
                case "procurar", "p":
                    pesquisarTarefa(searchTerm: argument)
                case "listar", "l":
                    listaNewUser.listarTarefas()
                case "help", "h":
                    help()
                case "finalizar", "f":
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
