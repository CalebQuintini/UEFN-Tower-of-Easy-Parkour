using { /Verse.org/Assets }

obstacle_course_colors := class:
    Level1_ColorString : string 
    Level2_ColorString : string
    Level3_ColorString : string 
    Level4_ColorString : string 
    Level5_ColorString : string 
    Level6_ColorString : string 
    Level7_ColorString : string 
 
ObstacleCourse0_Colors<public> := class(obstacle_course_colors):
    Level1_ColorString<override> : string = "0000FFFF"
    Level2_ColorString<override> : string = "800000FF"
    Level3_ColorString<override> : string = "778899FF"
    Level4_ColorString<override> : string = "663399FF"
    Level5_ColorString<override> : string = "8B4513FF"
    Level6_ColorString<override> : string = "FFE4E1FF"
    Level7_ColorString<override> : string = "FFA500FF"

ObstacleCourse1_Colors<public> := class(obstacle_course_colors):
    Level1_ColorString<override> : string = "00FFFFFF"
    Level2_ColorString<override> : string = "006400FF"
    Level3_ColorString<override> : string = "BDB76BFF"
    Level4_ColorString<override> : string = "FF8C00FF"
    Level5_ColorString<override> : string = "8B0000FF"
    Level6_ColorString<override> : string = "2F4F4FFF"
    Level7_ColorString<override> : string = "FF1493FF"

ObstacleCourse2_Colors<public> := class(obstacle_course_colors):
    Level1_ColorString<override> : string = "FFA07AFF"
    Level2_ColorString<override> : string = "4B0082FF"
    Level3_ColorString<override> : string = "FF69B4FF"
    Level4_ColorString<override> : string = "808000FF"
    Level5_ColorString<override> : string = "00FF7FFF"
    Level6_ColorString<override> : string = "008080FF"
    Level7_ColorString<override> : string = "4682B4FF"
    
ObstacleCourse3_Colors<public> := class(obstacle_course_colors):
    Level1_ColorString<override> : string = "FF0000FF"
    Level2_ColorString<override> : string = "000080FF"
    Level3_ColorString<override> : string = "7CFC00FF"
    Level4_ColorString<override> : string = "696969FF"
    Level5_ColorString<override> : string = "FFD700FF"
    Level6_ColorString<override> : string = "32CD32FF"
    Level7_ColorString<override> : string = "800080FF"

ObstacleCourse4_Colors<public> := class(obstacle_course_colors):
    Level1_ColorString<override> : string = "8FBC8BFF"
    Level2_ColorString<override> : string = "1E90FFFF"
    Level3_ColorString<override> : string = "E6E6FAFF"
    Level4_ColorString<override> : string = "FF00FFFF"
    Level5_ColorString<override> : string = "7FFFD4FF"
    Level6_ColorString<override> : string = "FF4500FF"
    Level7_ColorString<override> : string = "FFFF00FF"
