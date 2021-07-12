Original App Design Project
===

# Pathways

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app allows users to track their paths that they take when they go on walk's, run's or any sort of trip. Users can post pictures and notable locations on their path.

### App Evaluation
- **Category:** Fitness
- **Mobile:** This app is uniquely mobile because user's need to have their location services on in order to track their path and their camera to take pictures of notable places on their path
- **Story:** Allows users to keep track of their paths so that they could walk them later or share them with a friend, users an see paths their friends go on
- **Market:** People who go on walks alot, people with dogs, bikers
- **Habit:** Users can see paths their friends go on and try to beat them with time or distance of the path
- **Scope:** The first focus of the app would just to be tracking the path of the user and saving it so they can see it later. Later on features like sharing the path, friends, and competitions can be added.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can track their paths
* Users can see their paths on the map
* Users can see statistics about their walk
* Users can save their paths and view them later

**Optional Nice-to-have Stories**

* Users can share their paths with other users of pathways
* Users can add friends on pathways
* Users can take other user's path's
* Users can see path's their friends take
* Users can see paths that have been taken in their area
* Users can have either public (Friends and people around them can see) or private paths 
* Users can pause and resume their paths (Path sessions? or closest point on path to their current location)

### 2. Screen Archetypes
* Home
   * Users can start a new path here 
* Current Path View
   * Users can track their paths
   * Users can see their paths on the map
* Path Statistics View
   * Users can see statistics about their walk
* Taken Paths View
   * Users can save their paths and view them later
* Taken Path Detail View
   * Users can save their paths and view them later



### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Taken Paths View

**Flow Navigation** (Screen to Screen)

* Home
   * Current Path View
* Current Path View
   * Path Statistics View
   * Home
* Path Statistics View
    * Home
* Taken Paths View
    * Taken Path Detail View
* Landmark creation page

## Wireframes
![](https://i.imgur.com/BvO5na1.jpg)
![](https://i.imgur.com/fARJric.jpg)
![](https://i.imgur.com/LaFzgEo.jpg)


### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models

## Path
| Property    | Type       | Description                                                 |
| ----------- | ---------- | ----------------------------------------------------------- |
| pathName    | String     | Name of the path                                            |
| timeElapsed | Number     | Time it takes the path author to walk the path (in seconds) |
| createdAt   | DateTime   | When the path was Created                                   |
| startPoint  | Coordinate | Starting point of the path                                  |
| endPoint    | Coordinate | End point of the path                                       |
| distance    | Number     | The distance of the path (in meters)                        |
| pathId      | String     | id Unique to the path                                       |
| userId      | String     | Id of the user that created the path                        |

## Pathway
| Property | Type         | Description                                    |
| -------- | ------------ | ---------------------------------------------- |
| pathId   | String       | Id of the path the pathway belongs to          |
| path     | coordinate[] | A list of coordinates that represents the path |

## Landmark
| Property    | Type       | Description                             |
| ----------- | ---------- | --------------------------------------- |
| photos      | String[]   | List of URL's that point to an image    |
| title       | String     | title of the landmark                   |
| description | String     | Description of the landmark             |
| type        | String     | Either a Hazard or Landmark             |
| createdAt   | DateTime   | Date/Time the landmark was created      |
| landmarkId  | String     | Id of the landmark                      |
| pathId      | String     | Id of the path the landmark belongs to  |
| location    | Coordinate | location of the landmark along the path |

## User
| Property      | Type   | Description                          |
| ------------- | ------ | ------------------------------------ |
| username      | String | username of the user                 |
| email         | String | email of the user                    |
| password      | String | hashed string of the user's password |
| profile_image | String | image/file                           |
| totalPaths    | Number | number of paths the user has made    |

### Networking

        - getAllUserPaths(UserID) -> Path[], error
        - getPath(pathID) -> Path, error
        - postPath(Path) -> success, error
        - getAllLandmarks(pathID) -> Landmark[], error 
        - getUser(userID) -> User, error
        - registerUser(User) ->Success, error
        - loginUser(username, password) -> success, error
        - getAllPathsInArea(coordinate) -> Path[], error //Extra
        
- New Path/ End Path
    - (POST) Post the [PATH] the user created
- Explore/MapView
    - (GET) Get [PATH]s close to user's current location 
- Path Detail
    - (GET) Get the [PATHWAY] and [USER] associated with the path provided
- Landmark/Hazard List
    - (GET) Get all the [LANDMARK]s/hazards associated with the path
- Landmark/Hazard Detail
    - (GET) Get the images associated with the [LANDMARK]s/Hazard provided
- User Detail
    - (GET) Get [USER] and all [PATH]'s the user has created
- Walk Path
    - (GET) Get the [PATHWAY] associated with the provided path
### Existing API
#### Google Maps
Will be using the google maps SDK to implement the maps part of Pathways
https://developers.google.com/maps/documentation/ios-sdk/map
