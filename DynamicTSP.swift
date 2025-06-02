import Foundation

class TSPSolver {
    private let INF = Int.max / 2
    private var n: Int
    private var dist: [[Int]]
    private var memo: [[Int]]
    
    init(distances: [[Int]]) {
        self.n = distances.count
        self.dist = distances
        // inisialisasi tabel memoization
        // memo[mask][i] = biaya minimum untuk mengunjungi semua kota dalam mask dan berakhir di kota i
        self.memo = Array(repeating: Array(repeating: -1, count: n), count: 1 << n)
    }
    
    // fungsi utama untuk menyelesaikan tsp
    func solveTSP() -> (minCost: Int, path: [Int]) {
        // mulai dari kota 0, dengan mask yang hanya mengandung kota 0
        let minCost = tsp(mask: 1, currentCity: 0)
        let path = reconstructPath()
        return (minCost, path)
    }
    
    // fungsi rekursif dengan memoization
    private func tsp(mask: Int, currentCity: Int) -> Int {
        // base case: semua kota sudah dikunjungi, kembali ke kota awal
        if mask == (1 << n) - 1 {
            return dist[currentCity][0] == 0 ? INF : dist[currentCity][0]
        }
        
        // jika sudah dihitung sebelumnya, return dari memo
        if memo[mask][currentCity] != -1 {
            return memo[mask][currentCity]
        }
        
        var result = INF
        
        for nextCity in 0..<n {
            // jika kota belum dikunjungi dan ada jalur ke kota tersebut
            if (mask & (1 << nextCity)) == 0 && dist[currentCity][nextCity] != 0 {
                let newMask = mask | (1 << nextCity)
                let cost = dist[currentCity][nextCity] + tsp(mask: newMask, currentCity: nextCity)
                result = min(result, cost)
            }
        }
        
        // simpan hasil ke memo
        memo[mask][currentCity] = result
        return result
    }
    
    private func reconstructPath() -> [Int] {
        var path: [Int] = []
        var mask = 1
        var currentCity = 0
        
        path.append(currentCity)
        
        while mask != (1 << n) - 1 {
            var nextCity = -1
            var minCost = INF
            
            for city in 0..<n {
                if (mask & (1 << city)) == 0 && dist[currentCity][city] != 0 {
                    let newMask = mask | (1 << city)
                    let cost = dist[currentCity][city] + 
                              (memo[newMask][city] != -1 ? memo[newMask][city] : tsp(mask: newMask, currentCity: city))
                    
                    if cost < minCost {
                        minCost = cost
                        nextCity = city
                    }
                }
            }
            
            if nextCity != -1 {
                path.append(nextCity)
                mask |= (1 << nextCity)
                currentCity = nextCity
            } else {
                break
            }
        }
        
        path.append(0)
        return path
    }
}

func printMatrix(_ matrix: [[Int]], title: String) {
    print("\n=== \(title) ===")
    
    if matrix.isEmpty {
        print("matriks kosong!")
        return
    }
    
    // tampilkan header kolom
    print("    ", terminator: "")
    for i in 0..<matrix[0].count {
        print("\(i)".padding(toLength: 8, withPad: " ", startingAt: 0), terminator: "")
    }
    print()
    
    // tampilkan setiap baris
    for i in 0..<matrix.count {
        print("\(i): ", terminator: "")
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
    print("┌" + String(repeating: "─", count: 40) + "┐")
    print("│              HASIL OPTIMAL             │")
    print("├" + String(repeating: "─", count: 40) + "┤")
    
    let pathString = path.map { "kota \($0)" }.joined(separator: " → ")
    print("│ jalur: \(pathString)")
    
    // tampilkan total jarak
    if cost == Int.max / 2 {
        print("│ total jarak: tidak ada solusi")
    } else {
        print("│ total jarak: \(cost)")
    }
    
    print("└" + String(repeating: "─", count: 40) + "┘")
    print()
}

func printHeader() {
    print("╔════════════════════════════════════════════════════════════╗")
    print("║                  TSP DYNAMIC PROGRAMMING                   ║")
    print("║                          SOLVER                            ║")
    print("╠════════════════════════════════════════════════════════════╣")
    print("║ dibuat oleh: Kenneth Poenadi 13523040                      ║")
    print("║ kompleksitas waktu: O(n² × 2ⁿ)                             ║")
    print("║ kompleksitas ruang: O(n × 2ⁿ)                              ║")
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

// fungsi untuk menampilkan bantuan
func showHelp() {
    print("\n╔════════════════════════════════════════════════════════════╗")
    print("║                         BANTUAN                           ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print()
    print("TENTANG TSP:")
    print("   traveling salesman problem (tsp) adalah masalah optimisasi")
    print("   untuk mencari jalur terpendek yang mengunjungi semua kota")
    print("   tepat satu kali dan kembali ke kota asal.")
    print()
    print("ALGORITMA DYNAMIC PROGRAMMING:")
    print("   - menggunakan bitmask untuk merepresentasikan kota yang sudah dikunjungi")
    print("   - memoization untuk menghindari perhitungan berulang")
    print("   - kompleksitas: O(n² × 2ⁿ)")
    print()
    print("TIPS INPUT:")
    print("   - gunakan 0 untuk diagonal utama (jarak kota ke dirinya sendiri)")
    print("   - gunakan 0 untuk jalur yang tidak ada")
    print("   - disarankan maksimal 15 kota untuk performa optimal")
    print()
    print("FORMAT MATRIKS:")
    print("   - baris i kolom j = jarak dari kota i ke kota j")
    print("   - matriks boleh asimetris (jarak i→j ≠ jarak j→i)")
    print()
}

func getInputFromUser() {
    print("\n╔════════════════════════════════════════════════════════════╗")
    print("║                    INPUT MANUAL                           ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print()    
    // input jumlah kota dengan validasi
    print("masukkan jumlah kota (2-20): ", terminator: "")
    
    guard let input = readLine(), let n = Int(input), n >= 2 else {
        print("input tidak valid! harap masukkan angka yang benar.")
        return
    }
    
    // peringatan untuk jumlah kota besar
    if n > 15 {
        print("PERINGATAN:")
        print("   jumlah kota > 15 akan membutuhkan waktu komputasi yang lama!")
        print("   kompleksitas: O(\(n)² × 2^\(n)) = O(\(n * n) × \(1 << n))")
        print()
        print("lanjutkan? (y/n): ", terminator: "")
        
        if let confirm = readLine(), confirm.lowercased() != "y" {
            print("dibatalkan oleh user.")
            return
        }
    }
    
    var distances: [[Int]] = Array(repeating: Array(repeating: 0, count: n), count: n)
    
    print("\nmasukkan matriks jarak \(n)×\(n):")
    print("   tips: gunakan 0 untuk diagonal dan jalur yang tidak ada")
    print()
    
    for i in 0..<n {
        for j in 0..<n {
            if i == j {
                distances[i][j] = 0
                print("   jarak kota \(i) → kota \(j): 0 (diagonal)")
            } else {
                print("   jarak kota \(i) → kota \(j): ", terminator: "")
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
    
    print("memproses dengan dynamic programming...")
    print("   ini mungkin membutuhkan beberapa detik...")
    
    let startTime = Date()
    let solver = TSPSolver(distances: distances)
    let result = solver.solveTSP()
    let endTime = Date()
    let processingTime = endTime.timeIntervalSince(startTime)
    
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