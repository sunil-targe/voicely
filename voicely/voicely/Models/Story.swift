import Foundation


struct Story: Identifiable, Codable {
    let id: Int
    let name: String
    let thumbnailImageName: String
    let transcript: String
    let storyViewName: String
    
    init(id: Int, name: String, thumbnailImageName: String, transcript: String, storyViewName: String) {
        self.id = id
        self.name = name
        self.thumbnailImageName = thumbnailImageName
        self.transcript = transcript
        self.storyViewName = storyViewName
    }
    
    static let allStories: [Story] = [
        Story(
            id: 0,
            name: "The Brave Little Rabbit",
            thumbnailImageName: "brave_rabbit",
            transcript: "Once upon a time, there was a little rabbit who was afraid of everything. But when his friends needed help, he found the courage to be brave.",
            storyViewName: "BraveLittleRabbitView"
        ),
        Story(
            id: 1,
            name: "The Bear Family's Hibernation",
            thumbnailImageName: "bear_family",
            transcript: "The bear family prepares for their long winter sleep, teaching little ones about the importance of rest and preparation.",
            storyViewName: "BearFamilyHibernationView"
        ),
        Story(
            id: 2,
            name: "The Dragon Who Couldn't Breathe Fire",
            thumbnailImageName: "dragon_fire",
            transcript: "A young dragon struggles to breathe fire like other dragons, but discovers his own unique talents that make him special.",
            storyViewName: "DragonCouldntBreatheFireView"
        ),
        Story(
            id: 3,
            name: "The Dream of Flying",
            thumbnailImageName: "dream_of_flying",
            transcript: "A child dreams of flying through the clouds and discovers that imagination can take you anywhere you want to go.",
            storyViewName: "DreamOfFlyingView"
        ),
        Story(
            id: 4,
            name: "The Forest Friends and the Storm",
            thumbnailImageName: "forest_friends",
            transcript: "When a big storm comes to the forest, all the animals work together to help each other stay safe and warm.",
            storyViewName: "ForestFriendsStormView"
        ),
        Story(
            id: 5,
            name: "The Lost Kitten's Journey Home",
            thumbnailImageName: "lost_kitten",
            transcript: "A little kitten gets lost in the big city but finds her way back home with the help of kind strangers.",
            storyViewName: "LostKittenJourneyView"
        ),
        Story(
            id: 6,
            name: "The Mermaid's Ocean Lesson",
            thumbnailImageName: "mermaids_ocean",
            transcript: "A young mermaid learns about the importance of protecting the ocean and all its wonderful creatures.",
            storyViewName: "MermaidOceanLessonView"
        ),
        Story(
            id: 7,
            name: "The Secret Garden Discovery",
            thumbnailImageName: "secret_garden",
            transcript: "Children discover a hidden garden and learn about the magic of nature and growing beautiful things.",
            storyViewName: "SecretGardenDiscoveryView"
        ),
        Story(
            id: 8,
            name: "The Toys' Nighttime Adventure",
            thumbnailImageName: "toy_nighttime",
            transcript: "When the children are asleep, the toys come to life and have exciting adventures in the playroom.",
            storyViewName: "ToysNighttimeAdventureView"
        ),
        Story(
            id: 9,
            name: "The Young Wizard's Lesson",
            thumbnailImageName: "young_wizards",
            transcript: "A young wizard learns that the most powerful magic comes from kindness and helping others.",
            storyViewName: "YoungWizardLessonView"
        )
    ]
}
