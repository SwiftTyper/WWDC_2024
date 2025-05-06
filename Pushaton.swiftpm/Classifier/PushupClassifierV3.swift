//
// PushupClassifierV3.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML

/// Model Prediction Input Type
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
class PushupClassifierV3Input : MLFeatureProvider {

    /// poses as 1 × 15 × 16 3-dimensional array of floats
    var poses: MLMultiArray

    var featureNames: Set<String> {
        get {
            return ["poses"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "poses") {
            return MLFeatureValue(multiArray: poses)
        }
        return nil
    }
    
    init(poses: MLMultiArray) {
        self.poses = poses
    }

    convenience init(poses: MLShapedArray<Float>) {
        self.init(poses: MLMultiArray(poses))
    }

}


/// Model Prediction Output Type
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
class PushupClassifierV3Output : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// label as string value
    var label: String {
        return self.provider.featureValue(for: "label")!.stringValue
    }

    /// labelProbabilities as dictionary of strings to doubles
    var labelProbabilities: [String : Double] {
        return self.provider.featureValue(for: "labelProbabilities")!.dictionaryValue as! [String : Double]
    }

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(label: String, labelProbabilities: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["label" : MLFeatureValue(string: label), "labelProbabilities" : MLFeatureValue(dictionary: labelProbabilities as [AnyHashable : NSNumber])])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
class PushupClassifierV3 {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "PushupClassifierV3", withExtension:"mlmodelc")!
    }

    /**
        Construct PushupClassifierV3 instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of PushupClassifierV3.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `PushupClassifierV3.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct PushupClassifierV3 instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct PushupClassifierV3 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<PushupClassifierV3, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct PushupClassifierV3 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> PushupClassifierV3 {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct PushupClassifierV3 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<PushupClassifierV3, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(PushupClassifierV3(model: model)))
            }
        }
    }

    /**
        Construct PushupClassifierV3 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> PushupClassifierV3 {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return PushupClassifierV3(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as PushupClassifierV3Input

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as PushupClassifierV3Output
    */
    func prediction(input: PushupClassifierV3Input) throws -> PushupClassifierV3Output {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as PushupClassifierV3Input
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as PushupClassifierV3Output
    */
    func prediction(input: PushupClassifierV3Input, options: MLPredictionOptions) throws -> PushupClassifierV3Output {
        let outFeatures = try model.prediction(from: input, options:options)
        return PushupClassifierV3Output(features: outFeatures)
    }

    /**
        Make an asynchronous prediction using the structured interface

        - parameters:
           - input: the input to the prediction as PushupClassifierV3Input
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as PushupClassifierV3Output
    */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    func prediction(input: PushupClassifierV3Input, options: MLPredictionOptions = MLPredictionOptions()) async throws -> PushupClassifierV3Output {
        let outFeatures = try await model.prediction(from: input, options:options)
        return PushupClassifierV3Output(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - poses as 1 × 15 × 16 3-dimensional array of floats

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as PushupClassifierV3Output
    */
    func prediction(poses: MLMultiArray) throws -> PushupClassifierV3Output {
        let input_ = PushupClassifierV3Input(poses: poses)
        return try self.prediction(input: input_)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - poses as 1 × 15 × 16 3-dimensional array of floats

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as PushupClassifierV3Output
    */

    func prediction(poses: MLShapedArray<Float>) throws -> PushupClassifierV3Output {
        let input_ = PushupClassifierV3Input(poses: poses)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [PushupClassifierV3Input]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [PushupClassifierV3Output]
    */
    func predictions(inputs: [PushupClassifierV3Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [PushupClassifierV3Output] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [PushupClassifierV3Output] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  PushupClassifierV3Output(features: outProvider)
            results.append(result)
        }
        return results
    }
}
