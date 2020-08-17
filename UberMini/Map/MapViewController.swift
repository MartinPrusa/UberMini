//
//  MapViewController.swift
//  UberMini
//
//  Created by Martin Prusa on 17.08.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import MapKit

protocol MapDisplayLogic: AnyObject {
    func display(viewModel: Map.ViewModel)
}

final class MapViewController: UIViewController, MapDisplayLogic {

    var interactor: MapBusinessLogic!
    var router: (MapRoutingLogic & MapDataPassing)!
    private var map = MKMapView()
    private var usernameLabel = UILabel()
    private var streetLabel = UILabel()
    private var locationManager = CLLocationManager()

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupCleanSwift()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCleanSwift()
    }

    // MARK: - Setup

    private func setupCleanSwift() {
        let viewController = self
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.backgroundColor = .white
        layout()
        setupMap()
        setupLabels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        streetLabel.text = "Unknown"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    private func setupMap() {
        map.delegate = self
        map.showsTraffic = true
        map.showsUserLocation = true
    }

    private func setupLabels() {
        usernameLabel.textAlignment = .center
        streetLabel.textAlignment = .center
    }

    private func layout() {
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false

        let topMap = NSLayoutConstraint(item: map, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: .zero)
        let leftMap = NSLayoutConstraint(item: map, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: .zero)
        let rightMap = NSLayoutConstraint(item: map, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: .zero)


        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        let bottomMap = NSLayoutConstraint(item: map, attribute: .bottom, relatedBy: .equal, toItem: usernameLabel, attribute: .top, multiplier: 1.0, constant: -50)

        let leftUsernameLabel = NSLayoutConstraint(item: usernameLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 10)
        let rightUsernameLabel = NSLayoutConstraint(item: usernameLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -10)

        view.addSubview(streetLabel)
        streetLabel.translatesAutoresizingMaskIntoConstraints = false

        let bottomUsernameLabel = NSLayoutConstraint(item: usernameLabel, attribute: .bottom, relatedBy: .equal, toItem: streetLabel, attribute: .top, multiplier: 1.0, constant: -8)

        let leftStreetLabel = NSLayoutConstraint(item: streetLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 10)
        let rightStreetLabel = NSLayoutConstraint(item: streetLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let bottomStreetLabel = NSLayoutConstraint(item: usernameLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -80)

        view.addConstraints([topMap, leftMap, rightMap, bottomMap, leftUsernameLabel, rightUsernameLabel, bottomUsernameLabel, leftStreetLabel, rightStreetLabel, bottomStreetLabel])
    }

    // MARK: - DisplayLogic

    func display(viewModel: Map.ViewModel) {
        usernameLabel.text = viewModel.username
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        map.setRegion(region, animated: true)

        //first car
        let black = UpdatableAnnotation()
        black.title = "Black"
        black.coordinate = CLLocationCoordinate2D(latitude: map.userLocation.coordinate.latitude - 0.005, longitude: map.userLocation.coordinate.longitude - 0.005)
        if mapView.annotations.contains(where: { $0.title == "Black" }) == false {
            mapView.addAnnotation(black)
            black.startUpdateLocation()
        }

        //second car
        let black1 = UpdatableAnnotation()
        black1.title = "Black1"
        black1.coordinate = CLLocationCoordinate2D(latitude: map.userLocation.coordinate.latitude + 0.005, longitude: map.userLocation.coordinate.longitude + 0.005)
        if mapView.annotations.contains(where: { $0.title == "Black1" }) == false {
            mapView.addAnnotation(black1)
            black1.startUpdateLocation()
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = String(describing: MKAnnotationView.self)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        annotationView?.image = UIImage(systemName: "car.fill")

        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last?.streetName(completionBlock: { stretName in
            self.streetLabel.text = stretName
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        assert(false, error.localizedDescription)
    }
}
