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
    
    mutating func editarTarefa(titulo: String, novaTarefa:Tarefa){
        let tarefaToEditIndex: Int = lista.firstIndex(where: {
            $0.titulo == titulo
        })!
        
        lista[tarefaToEditIndex].titulo = novaTarefa.titulo
        lista[tarefaToEditIndex].descricao = novaTarefa.descricao
        lista[tarefaToEditIndex].concluida = novaTarefa.concluida
    }
    
    mutating func alterarStatusTarefa(titulo: String, status: Bool){
        let tarefaToEditIndex: Int = lista.firstIndex(where: {
            $0.titulo == titulo
        })!
        
        lista[tarefaToEditIndex].concluida = status
    }
    
    func listarTarefas(){
        var resultado: [String] = []
        for tarefa in lista{
            resultado.append(tarefa.titulo)
            print("Tarefa \(resultado.count)")
            print("Título: \(tarefa.titulo)")
            print("Descrição: \(tarefa.descricao)")
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
            let jsonData = try encoder.encode(listaJoao)
            
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

var lerLivros = Tarefa(titulo: "Harry potter", descricao: "Um livro sobre um mundo magico", concluida: false)
var academia = Tarefa(titulo: "Malhar", descricao: "Correr na esteira", concluida: false)
var farmacia = Tarefa(titulo: "Remedio", descricao: "Comprar antialergico", concluida: false)
var desenhar = Tarefa(titulo: "Desenhar", descricao: "estudar perspectiva", concluida: false)
var pintura = Tarefa(titulo: "Pintura", descricao: "estudar cores", concluida: false)
var pintura2 = Tarefa(titulo: "Pintura", descricao: "estudar sombreamento", concluida: false)

var swift = Tarefa(titulo: "Swift", descricao: "praticar structs", concluida: false)
var plantas = Tarefa(titulo: "Plantas", descricao: "aguar plantas", concluida: false)

var listaJoao = ListaTarefas(lista: [lerLivros,academia,farmacia,desenhar,pintura,pintura2])

//listaJoao.adicionarTarefa(novaTarefa: swift,plantas)
//listaJoao.removerTarefa(tarefaRemovida: "swift")
//listaJoao.listarTarefas()
//listaJoao.pesquisarTarefa(searchTerm: "pintura")

var listaNewUser = ListaTarefas(lista: [])
func newTarefa(){
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

func excluirTarefa(search: String) {
    if let tupla: EnumeratedSequence<[Tarefa]> = listaNewUser.pesquisarTarefa(searchTerm: search) {
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
    }//que saco github
}
func executarAplicacao(){
    var running: Bool = true
    print("""
        Ola! Bem vindo a nossa aplicação
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
                    newTarefa()
                case "remove":
                    excluirTarefa(search: argument)
                    print("remove")
                    print("Argument: \(argument)")
                case "edit":
                    print("edit")
                    print("Argument: \(argument)")
                case "changeStatus":
                    print("changeStatus")
                    print("Argument: \(argument)")
                case "search":
                    print("search")
                    print("Argument: \(argument)")
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
