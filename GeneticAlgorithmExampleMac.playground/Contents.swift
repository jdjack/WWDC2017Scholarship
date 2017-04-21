import Cocoa
import PlaygroundSupport
import SpriteKit




//Change these values as much as you like!

//Size of the scene, 600 x 600 works great on a MBP 15"
let sceneSize = CGSize(width: 600, height: 600)

//This is where the test subjects will start - you can pick any point within the size declared above
let startPoint = CGPoint(x: 300, y: 50)

//This is where the test subjects will try to get to - you can pick any point within the size declared above
let endPoint = CGPoint(x: 300, y: 550)

//The random seed for the flow field. Try "Jack" for a more boring field
let perlinSeed = "AAPL"

//How much "push" the field has (-2 to 2 works best, larger abs values make it more difficult, changing the sign may lead to the particles bombarding the ground)
let flowFieldIntensity: CGFloat = 2

//If it is running slowly, reduce this number. 300 produces nice, fast results; keep below 1000 to avoid issues
let numberOfTestSubjects = 300


//The number of flow field tiles per width - it's here to play around with, but is best left alone. 0.05 and 0.1 make interesting changes
let flowFieldScale:CGFloat = 0.05




//You can also add barriers by clicking, but this will slow down the process, and can at times make it impossible due to the flow field strength








//Leave this, it's boring scene initialisation

//Set the flowField sizes
let flowWidth = sceneSize.width * flowFieldScale
let flowHeight = sceneSize.height * flowFieldScale

//Generate the field
let noiseGenerator = Perlin2D(seed: perlinSeed)
let flowField = noiseGenerator.octaveMatrix(width: Int(flowWidth), height: Int(flowHeight), octaves: 6, persistance: 0.3)

//Setup the main view

let viewSize = CGSize(width: sceneSize.width, height: sceneSize.height + 200)
let view = MainView(frame: CGRect(origin: CGPoint.zero, size: viewSize))


//Create the scene
let scene = FlowFieldScene(size: sceneSize, flowField: flowField, flowFieldIntensity: flowFieldIntensity, parentView: view, numTestSubjects: numberOfTestSubjects, startPoint: startPoint, endPoint: endPoint)

//Create the view to hold the scene
let sceneView = SKView(frame: CGRect(origin: CGPoint.zero, size: sceneSize))
sceneView.showsFPS = true

//Setup the scene
scene.backgroundColor = SKColor.white
sceneView.presentScene(scene)


view.addSubview(sceneView)


//Display the view
PlaygroundPage.current.liveView = view
