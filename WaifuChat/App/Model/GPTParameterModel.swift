

import Foundation


struct GPTParameterModel: Encodable{
    
    let model = "gpt-3.5-turbo"
    let messages: [GPTMessage]
    let temperature = 1
    let max_tokens = 256
    let top_p = 1
    let frequency_penalty = 0
    let presence_penalty = 0
    
}
