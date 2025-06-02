import Foundation

class TSPSolver {
    private let INF = Int.max / 2
    private var n: Int
    private var dist: [[Int]]
    private var memo: [Int: [Int: Int]] // f(i, S) -> cost
    private var choice: [Int: [Int: Int]] // J(i, S) -> next city choice
    
    init(distances: [[Int]]) {
        self.n = distances.count
        self.dist = distances
        self.memo = [:]
        self.choice = [:]
    }
    
    // fungsi utama untuk menyelesaikan tsp menggunakan algoritma dari persoalan
    func solveTSP() -> (minCost: Int, path: [Int]) {
        // tahap 1: basis f(i, ∅) = c_i1 untuk semua i ≠ 1
        for i in 1..<n {
            setMemo(i: i, S: [], value: dist[i][0])
        }
        
        // tahap 2 sampai n-1: hitung f(i, S) untuk |S| = 1, 2, ..., n-2
        for subsetSize in 1...(n-2) {
            generateSubsets(size: subsetSize)
        }
        
        // tahap akhir: hitung f(1, V-{1}) = tur terpendek
        let allCitiesExceptFirst = Array(1..<n)
        let minCost = computeF(i: 0, S: allCitiesExceptFirst)
        let path = reconstructOptimalPath()
        
        return (minCost, path)
    }
    
    // generate semua subset berukuran 'size' dan hitung f(i, S)
    private func generateSubsets(size: Int) {
        let cities = Array(1..<n)
        let subsets = combinations(of: cities, size: size)
        
        for subset in subsets {
            for i in 0..<n {
                if i != 0 && !subset.contains(i) { 
                    _ = computeF(i: i, S: subset)
                }
            }
        }
    }
    
    // hitung f(i, S) = min_{j∈S} {c_ij + f(j, S-{j})}
    private func computeF(i: Int, S: [Int]) -> Int {
        // cek apakah sudah dihitung sebelumnya
        if let cached = getMemo(i: i, S: S) {
            return cached
        }
        
        // basis: jika S kosong, return c_i1
        if S.isEmpty {
            let result = dist[i][0] == 0 ? INF : dist[i][0]
            setMemo(i: i, S: S, value: result)
            return result
        }
        
        var minCost = INF
        var bestChoice = -1
        
        // coba semua j ∈ S
        for j in S {
            // pastikan ada jalur dari i ke j
            if dist[i][j] > 0 || (i == j && dist[i][j] == 0) {
                let newS = S.filter { $0 != j } // S - {j}
                let cost = dist[i][j] + computeF(i: j, S: newS)
                
                if cost < minCost {
                    minCost = cost
                    bestChoice = j
                }
            }
        }
        
        setMemo(i: i, S: S, value: minCost)
        if bestChoice != -1 {
            setChoice(i: i, S: S, choice: bestChoice)
        }
        
        return minCost
    }
    
    private func reconstructOptimalPath() -> [Int] {
        var path = [0] 
        var currentCity = 0
        var remainingCities = Array(1..<n)
        
        while !remainingCities.isEmpty {
            guard let nextCity = getChoice(i: currentCity, S: remainingCities) else {
                var bestNext = -1
                var bestCost = INF
                
                for city in remainingCities {
                    let newRemaining = remainingCities.filter { $0 != city }
                    let cost = dist[currentCity][city] + (getMemo(i: city, S: newRemaining) ?? INF)
                    if cost < bestCost {
                        bestCost = cost
                        bestNext = city
                    }
                }
                
                if bestNext == -1 { break }
                path.append(bestNext)
                currentCity = bestNext
                remainingCities = remainingCities.filter { $0 != bestNext }
                continue
            }
            
            path.append(nextCity)
            currentCity = nextCity
            remainingCities = remainingCities.filter { $0 != nextCity }
        }
        
        path.append(0) // kembali ke kota awal
        return path
    }
    
    private func encodeSubset(_ S: [Int]) -> Int {
        var encoded = 0
        for city in S {
            encoded |= (1 << city)
        }
        return encoded
    }
    
    private func getMemo(i: Int, S: [Int]) -> Int? {
        let encoded = encodeSubset(S)
        return memo[i]?[encoded]
    }
    
    private func setMemo(i: Int, S: [Int], value: Int) {
        let encoded = encodeSubset(S)
        if memo[i] == nil {
            memo[i] = [:]
        }
        memo[i]![encoded] = value
    }
    
    private func getChoice(i: Int, S: [Int]) -> Int? {
        let encoded = encodeSubset(S)
        return choice[i]?[encoded]
    }
    
    private func setChoice(i: Int, S: [Int], choice: Int) {
        let encoded = encodeSubset(S)
        if self.choice[i] == nil {
            self.choice[i] = [:]
        }
        self.choice[i]![encoded] = choice
    }
    
    // generate kombinasi subset
    private func combinations(of array: [Int], size: Int) -> [[Int]] {
        if size == 0 { return [[]] }
        if array.isEmpty { return [] }
        
        let head = array[0]
        let tail = Array(array[1...])
        
        let withHead = combinations(of: tail, size: size - 1).map { [head] + $0 }
        let withoutHead = combinations(of: tail, size: size)
        
        return withHead + withoutHead
    }
    
    func printCalculationSteps() {
        print("\n🔍 TAHAPAN PERHITUNGAN TSP:")
        print(String(repeating: "=", count: 50))
        
        // tahap 1: basis
        print("\nTAHAP 1 - BASIS f(i, ∅):")
        for i in 1..<n {
            if let value = getMemo(i: i, S: []) {
                print("f(\(i+1), ∅) = c_{\(i+1),1} = \(value)")
            }
        }
        
        for subsetSize in 1...(n-2) {
            print("\nTAHAP \(subsetSize + 1) - SUBSET UKURAN \(subsetSize):")
            let cities = Array(1..<n)
            let subsets = combinations(of: cities, size: subsetSize)
            
            for subset in subsets.sorted(by: { $0.lexicographicallyPrecedes($1) }) {
                for i in 0..<n {
                    if i != 0 && !subset.contains(i) {
                        if let value = getMemo(i: i, S: subset),
                           let nextChoice = getChoice(i: i, S: subset) {
                            let subsetStr = subset.map { "\($0+1)" }.joined(separator: ",")
                            print("f(\(i+1), {\(subsetStr)}) = \(value), pilih kota \(nextChoice+1)")
                        }
                    }
                }
            }
        }
        
        // hasil akhir
        let allCities = Array(1..<n)
        if let finalCost = getMemo(i: 0, S: allCities),
           let firstChoice = getChoice(i: 0, S: allCities) {
            let allCitiesStr = allCities.map { "\($0+1)" }.joined(separator: ",")
            print("\nHASIL AKHIR:")
            print("f(1, {\(allCitiesStr)}) = \(finalCost), pilih kota \(firstChoice+1)")
        }
        
        print(String(repeating: "=", count: 50))
    }
}

func printMatrix(_ matrix: [[Int]], title: String) {
    print("\n=== \(title) ===")
    
    if matrix.isEmpty {
        print("matriks kosong!")
        return
    }
    
    // tampilkan header kolom dengan nomor kota 1,2,3,...
    print("    ", terminator: "")
    for i in 0..<matrix[0].count {
        print("kota\(i+1)".padding(toLength: 8, withPad: " ", startingAt: 0), terminator: "")
    }
    print()
    
    // tampilkan setiap baris
    for i in 0..<matrix.count {
        print("kota\(i+1):", terminator: "")
        for j in 0..<matrix[i].count {
            let value = matrix[i][j]
            if value == Int.max / 2 {
                print("INF".padding(toLength: 8, withPad: " ", startingAt: 0), terminator: "")
            } else {
                print("\(value)".padding(toLength: 8, withPad: " ", startingAt: 0), terminator: "")
            }
        }
        print()
    }
    print()
}

func printPath(_ path: [Int], cost: Int) {
    print("┌" + String(repeating: "─", count: 50) + "┐")
    print("│                HASIL OPTIMAL                 │")
    print("├" + String(repeating: "─", count: 50) + "┤")
    
    // konversi ke nomor kota yang dimulai dari 1
    let pathString = path.map { "kota \($0 + 1)" }.joined(separator: " → ")
    print("│ jalur: \(pathString)")
    
    // tampilkan total jarak
    if cost == Int.max / 2 {
        print("│ total jarak: tidak ada solusi")
    } else {
        print("│ total jarak: \(cost)")
    }
    
    print("└" + String(repeating: "─", count: 50) + "┘")
    print()
}

func printHeader() {
    print("╔════════════════════════════════════════════════════════════╗")
    print("║                  TSP DYNAMIC PROGRAMMING                   ║")
    print("║                          SOLVER                            ║")
    print("╠════════════════════════════════════════════════════════════╣")
    print("║ dibuat oleh: Kenneth Poenadi 13523040                      ║")
    print("║ menggunakan f(i,S) = min{c_ij + f(j, S-{j})}               ║")
    print("║ kompleksitas: O(n² × 2ⁿ)                                   ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print()
}

func printMenu() {
    print("┌─────────────────────────────────────┐")
    print("│           PILIHAN MENU              │")
    print("├─────────────────────────────────────┤")
    print("│ 1. input manual                     │")
    print("│ 2. bantuan                          │")
    print("│ 3. keluar                           │")
    print("└─────────────────────────────────────┘")
    print()
    print("masukkan pilihan (1-3): ", terminator: "")
}

func showHelp() {
    print("\n╔════════════════════════════════════════════════════════════╗")
    print("║                         BANTUAN                           ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print()
    print("ALGORITMA YANG DIGUNAKAN:")
    print("   Program ini menggunakan algoritma dari Persoalan 4:")
    print("   f(i, S) = min{c_ij + f(j, S-{j})} untuk j ∈ S")
    print("   dengan basis f(i, ∅) = c_i1")
    print()
    print("TAHAPAN ALGORITMA:")
    print("   1. Tahap 1: Hitung basis f(i, ∅) = c_i1")
    print("   2. Tahap 2-n: Hitung f(i, S) untuk |S| = 1, 2, ..., n-2")
    print("   3. Tahap akhir: Hitung f(1, V-{1}) = tur terpendek")
    print("   4. Rekonstruksi jalur menggunakan choice table J(i,S)")
    print()
    print("NOTASI:")
    print("   - Kota dinomori 1, 2, ..., n (program menggunakan index 0-based)")
    print("   - Tur dimulai dan berakhir di kota 1")
    print("   - c_ij = jarak dari kota i ke kota j")
    print("   - S = subset kota yang harus dikunjungi")
    print()
    print("TIPS INPUT:")
    print("   - Gunakan 0 untuk diagonal utama")
    print("   - Gunakan nilai > 0 untuk jarak antar kota")
    print("   - Matriks boleh asimetris (c_ij ≠ c_ji)")
    print("   - Disarankan maksimal 15 kota untuk performa optimal")
    print()
}

func getInputFromUser() {
    print("\n╔════════════════════════════════════════════════════════════╗")
    print("║                    INPUT MANUAL                           ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print()    
    
    print("masukkan jumlah kota (2-15): ", terminator: "")
    
    guard let input = readLine(), let n = Int(input), n >= 2 && n <= 15 else {
        print("input tidak valid! harap masukkan angka 2-15.")
        return
    }
    
    // peringatan untuk kota banyak
    if n > 10 {
        print("PERINGATAN:")
        print("   jumlah kota > 10 akan membutuhkan waktu komputasi yang lama!")
        print("   kompleksitas: O(\(n)² × 2^\(n))")
        print()
        print("lanjutkan? (y/n): ", terminator: "")
        
        if let confirm = readLine(), confirm.lowercased() != "y" {
            print("dibatalkan oleh user.")
            return
        }
    }
    
    var distances: [[Int]] = Array(repeating: Array(repeating: 0, count: n), count: n)
    
    print("\nmasukkan matriks jarak \(n)×\(n):")
    print("   (kota dinomori 1, 2, ..., \(n))")
    print()
    
    for i in 0..<n {
        for j in 0..<n {
            if i == j {
                distances[i][j] = 0
                print("   jarak kota \(i+1) → kota \(j+1): 0 (diagonal)")
            } else {
                print("   jarak kota \(i+1) → kota \(j+1): ", terminator: "")
                if let input = readLine(), let distance = Int(input), distance >= 0 {
                    distances[i][j] = distance
                } else {
                    print("   input tidak valid, menggunakan nilai 0")
                    distances[i][j] = 0
                }
            }
        }
    }
    
    printMatrix(distances, title: "matriks jarak yang dimasukkan")
    
    print("memproses dengan algoritma f(i,S)...")
    print("   menghitung f(i,S) untuk semua subset S...")
    
    let startTime = Date()
    let solver = TSPSolver(distances: distances)
    let result = solver.solveTSP()
    let endTime = Date()
    let processingTime = endTime.timeIntervalSince(startTime)
    
    // tampilkan tahapan perhitungan untuk debugging
    print("\n📊 DETAIL PERHITUNGAN:")
    solver.printCalculationSteps()
    
    if result.minCost == Int.max / 2 {
        print("\ntidak ada solusi yang valid!")
        print("   kemungkinan penyebab:")
        print("   - graf tidak terhubung")
        print("   - ada kota yang tidak bisa dicapai")
    } else {
        printPath(result.path, cost: result.minCost)
        print("waktu komputasi: \(String(format: "%.3f", processingTime)) detik")
    }
}

func main() {
    printHeader()
    
    while true {
        printMenu()
        
        guard let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { 
            continue 
        }
        
        print()
        
        switch choice {
        case "1":
            getInputFromUser()
        case "2":
            showHelp()
        case "3":
            print("╔════════════════════════════════════════╗")
            print("║           TERIMA KASIH!                ║")
            print("║     telah menggunakan tsp solver       ║")
            print("╚════════════════════════════════════════╝")
            return
        default:
            print("pilihan tidak valid! silakan pilih 1-3.")
        }
        
        print("\n" + String(repeating: "═", count: 60) + "\n")
        
        print("tekan enter untuk kembali ke menu...")
        _ = readLine()
    }
}

main()