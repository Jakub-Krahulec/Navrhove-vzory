import Foundation

// MARK: - Single Responsibility Principle
//  Měl bych se vždy zamýšlet nad odpovědností jednotlivých objektů a držet se co největší jednoduchosti - každý objekt by měl mít JEDNU svoji odpovědnost... například -> nemít metodu pro ukládání do souborů v každé třídě, ale mít speciální třídu na ukládání souborů a v tomhle duchu si držet jasné, jednoduché třídy


// MARK: - Open-Closed Principle
// Objekty by měly být otevřené pro rozšíření, ale uzavřené pro modifikaci - když mám už napsanou a otestovanou třídu, tak bych ji již neměl měnit ve snaze rozšířit funkcionalitu, měl bych využít OOP a dědění namísto modifikace.



// MARK: - Liskov Subtitution Principle
// Pokud mám metodu, která příjímá base objekt, tak by měla vždy fungovat i pokud na vstupu bude subObjekt. Při porušení by se mohlo stát, že v subType přepíšu nějakou vlastnosti, která může v metodě vyvolat nečekané věci


// MARK: - Interface Segregation Principle
// Neměl bych vkládat mnoho věcí do protoclu, naopak držet opět co v největší jednoduchosti a mít jich raději víc a jasných, další věc je je že některé metody by nemusely nutně potřebovat všechny objekty, ale stejně by se musely zbytečně implementovat (YAGNI - You Ain't Gonna Need It)

// MARK: - Dependency Inversion Principle
// High level objekt by neměly být závislé na low level objektech ale měla by se použít abstrakce -> Low level například: Nějaký objekt, který přímo určuje datovou strukturu, High Level například: objekt který s tou strukturou pracuje -> je dobré mu předat nějaký protokol a využít tak abstrakci
