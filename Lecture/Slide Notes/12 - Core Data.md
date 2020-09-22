# Lecture 12 - Core Data

* Used to store/retrieve data in a database

* Core Data does storage in SQL
* Core Data will add some code in SceneDelegate.swift

    ```swift
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let airport = Airport.withICAO("KSFO", context: context)
    airport.fetchIncomingFlights()
    let contentView = FlightsEnrouteView(flightSearch: FlightSearch(destination: airport))
                .environment(\.managedObjectContext, context)
    
    ```

* Essentially creates a map with "relationships" of type `NSSet`

  * Xcode will generate classes for the map

  * We **use extensions** to add own methods and vars to classes

  * These objects - **ObservableObjects** are the source of data

  * `@FetchRequest` like `ObservedObject` fetches the objects constantly

    ```swift
    @FetchRequest var flights: FetchedResults<Flight>
        
    init(_ flightSearch: FlightSearch) {
        let request = Flight.fetchRequest(flightSearch.predicate)
        _flights = FetchRequest(fetchRequest: request)
    }
    ```

* Adds code in `SceneDelegate`

  * First line gets a window `NSManagedObjectContext` onto the database to access objects

  * Second line passes context into the `@Environment` of SwiftUI Views

  * `.predicate` to specify what kind of date to fetch

  * `.sortDescriptors` to sort the Data

  * `.fetch` to Fetch

    ```swift
    @Environnment(\.managedObjectContext) var context
    let flight = Flight(context: context)
    
    // Adding data
    flight.aircraft = “B737” 
    let ksjc = Airport(context: context)
    ksjc.icao = “KSJC” 
    flight.origin = ksjc  // this would auto add flight to ksjc.flightsFrom too
    
    // Saving 
    try? context.save()
    
    // Fetching Data
    let request = NSFetchRequest<Flight>(entityName: “Flight”)
    // To specify what kind of data to fetch
    request.predicate = NSPredicate(format: “arrival < %@ and origin = %@“, Date(), ksjc)
    // To sort the Array - key: name you want to sort by
    request.sortDescriptors = [NSSortDescriptor(key: “ident”, ascending: true)]
    // To fetch
    let flights = try? context.fetch(request) // nil if failed, [] if no flights
    ```

    

## Demo in ViewModel

* In AppName.xcdatamodeld, input the respective **entities** (classes) & **attributes** (vars)

* `import CoreData`

* To convert from relationship's  `NSSet` to `Set<Flight>`:

  ```swift
  var flightsTo: Set<Flight> {
      get { (flightsTo_ as? Set<Flight>) ?? [] }
      set { flightsTo_ = newValue as NSSet }
  }
  ```

* *Context in environment is not connected to a persistant store coordinator* Error - Pass environment into the sheet / modal etc.

  ```swift
  @Environment(\.managedObjectContext) var context
  
  .sheet(isPresented: $showFilter) {
      FilterFlights(flightSearch: self.$flightSearch, isPresented: self.$showFilter)
          // Pass context into sheet
          .environment(\.managedObjectContext, self.context)
  }
  ```

* How viewmodel deal with coredata？

*   ```swift
  let request = NSFetchRequest<Airport> (entityName: "Airport")
  request.predicate = NSPredicate(format: "icao_ = %@", icao)
  request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
  let airports = try? context.fetch(request) ?? []
  
  ```
  
  ```swift
      
  static func withICAO(_ icao: String, context: NSManagedObjectContext) -> Airport {
          // look up icao in Core Data
          let request = fetchRequest(NSPredicate(format: "icao_ = %@", icao))
          let airports = (try? context.fetch(request)) ?? []
          if let airport = airports.first {
              // if found, return it
              return airport
          } else {
              // if not, create one and fetch from FlightAware
              let airport = Airport(context: context)
            airport.icao = icao
              AirportInfoRequest.fetch(icao) { airportInfo in
                  self.update(from: airportInfo, context: context)
              }
              return airport
          }
      }
  ```
  
* icao_ means it won't be nil. This thing be not Optional anymore.

   ```swift
       //icao
      var icao: String {
          get { icao_! } // TODO: maybe protect against when app ships?
          set { icao_ = newValue }
      }
  ```


## Demo in View
* In the view using wrapped value 

*   ```swift
      @FetchRequest var flights: FetchedResults<Flight>
        
      init(_ flightSearch: FlightSearch) {
          let request = Flight.fetchRequest(flightSearch.predicate)
          _flights = FetchRequest(fetchRequest: request)
      }
  ```

* In the view

*   ```swift
          @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
      @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>
      
    ```

* Remeber to pass context in environment 

*   ```swift
     @Environment(\.managedObjectContext) var context
    
    .sheet(isPresented: $showFilter) {
                FilterFlights(flightSearch: self.$flightSearch, isPresented: self.$showFilter)
                    .environment(\.managedObjectContext, self.context)
            }
    ```

