import Foundation
import ArgumentParser

struct Tarefa : Codable {
    var titulo: String
    var descricao: String
    var concluida: Bool
}

struct ListaTarefas : Codable {
    var lista: [Tarefa]
    
    mutating func adicionarTarefa(novaTarefa: Tarefa...) -> Void{
        lista.append(contentsOf: novaTarefa)
    }
    
    mutating func removerTarefa(tarefaRemovida: String) -> Void{
        if let tarefaToRemove = lista.filter({ $0.titulo.lowercased() == tarefaRemovida.lowercased() }).first {
            lista.removeAll(where: { tarefa in
                tarefaToRemove.titulo == tarefa.titulo
            })} else {
                print("Essa tarefa não existe :(")
            }
    }
    
    mutating func editarTarefa(tarefaAntiga: Tarefa, novaTarefa:Tarefa){
        if let index: Int = lista.firstIndex(where: {tarefa in
            tarefa.titulo == tarefaAntiga.titulo && tarefa.descricao == tarefaAntiga.descricao
        }){
            lista[index].titulo = novaTarefa.titulo
            lista[index].descricao = novaTarefa.descricao
            lista[index].concluida = novaTarefa.concluida
        }
    }
    
    mutating func alterarStatusTarefa(searchTerm: String){
        if let tarefaToEditIndex = lista.firstIndex(where: {$0.titulo.lowercased().contains(searchTerm.lowercased()) ||  $0.descricao.lowercased().contains(searchTerm.lowercased())
}) {
            lista[tarefaToEditIndex].concluida = !lista[tarefaToEditIndex].concluida
        } else {
            print("Tarefa não encontrada :( ")
        }

    }
    
    func listarTarefas(){
        var resultado: [String] = []
        for tarefa in lista{
            resultado.append(tarefa.titulo)
            print("Tarefa \(resultado.count)")
            print("Título: \(tarefa.titulo)")
            print("Descrição: \(tarefa.descricao)")
            print(tarefa.concluida ? "A tarefa foi concluída": "A tarefa não foi concluída")
            print("")
        }
        
    }
    
    func pesquisarTarefa(searchTerm: String) -> EnumeratedSequence<[Tarefa]>?{
        var result: [Tarefa] = []
            result = lista.filter({ tarefa in
                tarefa.titulo.lowercased().contains(searchTerm.lowercased()) ||  tarefa.descricao.lowercased().contains(searchTerm.lowercased())
            })
        if result.isEmpty{
            print("Nenhuma tarefa encontrada :( ")
            return nil
        }else{
            print("")
            print("\(result.count) Tarefas encontradas:")
            print("")
            for (index, _) in result.enumerated(){
                print("Tarefa \(index+1)")
                print("Título: \(result[index].titulo)")
                print("Descrição: \(result[index].descricao)")
                print("")
            }
            return result.enumerated()
        }
    }
    
    func criarJSON(){
        // Criar uma instância de JSONEncoder
        let encoder = JSONEncoder()
        do {
            // Tentar codificar a struct para JSON
            let jsonData = try encoder.encode(listaNewUser)
            
            // Converta para uma string de JSON para impressão
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            // Criar arquivo e salvar
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathExtension("listaTarefas.json")
                
                do {
                    try jsonData.write(to: fileURL)
                }
                catch { print("Error")}
            }
        } catch {
            print("Erro ao codificar para JSON: \(error)")
        }
    }
    
}

var listaNewUser = ListaTarefas(lista: [])


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
