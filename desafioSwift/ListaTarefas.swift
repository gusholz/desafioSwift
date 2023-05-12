//
//  ListaTarefas.swift
//  desafioSwift
//
//  Created by userext on 11/05/23.
//

import Foundation

struct ListaTarefas : Codable {
    var lista: [Tarefa]
    
    mutating func inicializar() -> Void {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("listaTarefas.json")
            do {
                let data = try Data(contentsOf: filePath)
                let decoder = JSONDecoder()
                lista = try decoder.decode([Tarefa].self, from: data)
            } catch {
                print("Sem arquivo de inicialização. Comecando novo registro.")
            }
        }
    }
    
    func criarJSON(){
        // Criar uma instância de JSONEncoder
        let encoder = JSONEncoder()
        do {
            // Tentar codificar a struct para JSON
            let jsonData = try encoder.encode(lista)

            // Criar arquivo e salvar
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("listaTarefas.json")
                
                do {
                    try jsonData.write(to: fileURL)
                }
                catch { print("Não foi possível salvar o JSON")}
            }
        } catch {
            print("Erro ao codificar para JSON: \(error)")
        }
    }
    
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
}
