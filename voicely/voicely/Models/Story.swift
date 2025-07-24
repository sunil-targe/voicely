import Foundation


struct Story: Identifiable, Codable {
    let id: UUID
    let name: String
    let thumbnailImageName: String
    let transcript: String
    let storyViewName: String
    
    init(id: UUID = UUID(), name: String, thumbnailImageName: String, transcript: String, storyViewName: String) {
        self.id = id
        self.name = name
        self.thumbnailImageName = thumbnailImageName
        self.transcript = transcript
        self.storyViewName = storyViewName
    }
    
    static let allStories: [Story] = [
        Story(
            name: "The Brave Little Rabbit",
            thumbnailImageName: "brave_rabbit",
            transcript: "Once upon a time, there was a little rabbit who was afraid of everything. But when his friends needed help, he found the courage to be brave.",
            storyViewName: "BraveLittleRabbitView"
        ),
        Story(
            name: "The Bear Family's Hibernation",
            thumbnailImageName: "brave_rabbit",
            transcript: "The bear family prepares for their long winter sleep, teaching little ones about the importance of rest and preparation.",
            storyViewName: "BearFamilyHibernationView"
        ),
        Story(
            name: "The Dragon Who Couldn't Breathe Fire",
            thumbnailImageName: "brave_rabbit",
            transcript: "A young dragon struggles to breathe fire like other dragons, but discovers his own unique talents that make him special.",
            storyViewName: "DragonCouldntBreatheFireView"
        ),
        Story(
            name: "The Dream of Flying",
            thumbnailImageName: "brave_rabbit",
            transcript: "A child dreams of flying through the clouds and discovers that imagination can take you anywhere you want to go.",
            storyViewName: "DreamOfFlyingView"
        ),
        Story(
            name: "The Forest Friends and the Storm",
            thumbnailImageName: "brave_rabbit",
            transcript: "When a big storm comes to the forest, all the animals work together to help each other stay safe and warm.",
            storyViewName: "ForestFriendsStormView"
        ),
        Story(
            name: "The Lost Kitten's Journey Home",
            thumbnailImageName: "brave_rabbit",
            transcript: "A little kitten gets lost in the big city but finds her way back home with the help of kind strangers.",
            storyViewName: "LostKittenJourneyView"
        ),
        Story(
            name: "The Mermaid's Ocean Lesson",
            thumbnailImageName: "brave_rabbit",
            transcript: "A young mermaid learns about the importance of protecting the ocean and all its wonderful creatures.",
            storyViewName: "MermaidOceanLessonView"
        ),
        Story(
            name: "The Secret Garden Discovery",
            thumbnailImageName: "brave_rabbit",
            transcript: "Children discover a hidden garden and learn about the magic of nature and growing beautiful things.",
            storyViewName: "SecretGardenDiscoveryView"
        ),
        Story(
            name: "The Toys' Nighttime Adventure",
            thumbnailImageName: "brave_rabbit",
            transcript: "When the children are asleep, the toys come to life and have exciting adventures in the playroom.",
            storyViewName: "ToysNighttimeAdventureView"
        ),
        Story(
            name: "The Young Wizard's Lesson",
            thumbnailImageName: "brave_rabbit",
            transcript: "A young wizard learns that the most powerful magic comes from kindness and helping others.",
            storyViewName: "YoungWizardLessonView"
        )
    ]
}
