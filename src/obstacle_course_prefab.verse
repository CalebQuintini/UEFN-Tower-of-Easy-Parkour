using { /Verse.org/SceneGraph }
using { /Verse.org/SpatialMath }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

obstacle_course_prefab<public> := class:
    ConstructObstacleCoursePrefab<public>()<transacts>:?entity = false

ObstacleCourse0 := class<concrete>(obstacle_course_prefab):
    # Constructs the entity prefab associated with this obstacle course.
    ConstructObstacleCoursePrefab<override>()<transacts>:?entity =
        NewObstacleCourse := CoursePrefabs.Prefab_Course0{}
        option{NewObstacleCourse}
ObstacleCourse1 := class<concrete>(obstacle_course_prefab):
    # Constructs the entity prefab associated with this obstacle course.
    ConstructObstacleCoursePrefab<override>()<transacts>:?entity=
        NewObstacleCourse := CoursePrefabs.Prefab_Course1{}
        option{NewObstacleCourse}
ObstacleCourse2 := class<concrete>(obstacle_course_prefab):
    # Constructs the entity prefab associated with this obstacle course.
    ConstructObstacleCoursePrefab<override>()<transacts>:?entity=
        NewObstacleCourse := CoursePrefabs.Prefab_Course2{}
        option{NewObstacleCourse}
ObstacleCourse3 := class<concrete>(obstacle_course_prefab):
    # Constructs the entity prefab associated with this obstacle course.
    ConstructObstacleCoursePrefab<override>()<transacts>:?entity=
        NewObstacleCourse := CoursePrefabs.Prefab_Course3{}
        option{NewObstacleCourse}
ObstacleCourse4 := class<concrete>(obstacle_course_prefab):
    # Constructs the entity prefab associated with this obstacle course.
    ConstructObstacleCoursePrefab<override>()<transacts>:?entity=
        NewObstacleCourse := CoursePrefabs.Prefab_Course4{}
        option{NewObstacleCourse}
