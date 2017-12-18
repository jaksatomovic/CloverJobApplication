import Foundation

struct Repo : Codable {
    let access_token : String?

	enum CodingKeys: String, CodingKey {

		case access_token = "access-token"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
	}

}
