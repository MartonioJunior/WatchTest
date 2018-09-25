//
//  Remedio.swift
//  WatchTest
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit

class Remedio {
    var nome: String
    var intervalo: Int
    var descricao: String
    var dataInicio: Date
    
    init(nome: String, intervalo: Int, descricao: String, dataInicio: Date) {
        self.nome = nome
        self.intervalo = intervalo
        self.dataInicio = dataInicio
        self.descricao = descricao
    }
}
