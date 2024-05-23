import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var restaurants: [RestaurantModel]
    @Binding var selectedRestaurant: RestaurantModel?
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let evryCoordinate = CLLocationCoordinate2D(latitude: 48.6298, longitude: 2.4405)
        let region = MKCoordinateRegion(center: evryCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        uiView.setRegion(region, animated: true)
        
        uiView.removeAnnotations(uiView.annotations)
        for restaurant in restaurants {
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.nom
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

            func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                if let annotationTitle = view.annotation?.title {
                    if let name = annotationTitle {
                        if let restaurant = parent.restaurants.first(where: { $0.nom == name }) {
                            parent.selectedRestaurant = restaurant
                        }
                    }
                }
            }
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}
