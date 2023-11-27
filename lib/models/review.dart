// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    Model model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String? username;
    String? book;
    int? rate;
    String? review;
    DateTime date;

    Fields({
        required this.user,
        required this.username,
        required this.book,
        required this.rate,
        required this.review,
        required this.date,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        username: json["username"],
        book: json["book"],
        rate: json["rate"],
        review: json["review"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "username": username,
        "book": book,
        "rate": rate,
        "review": review,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };
}

enum Model {
    MAIN_REVIEW
}

final modelValues = EnumValues({
    "main.review": Model.MAIN_REVIEW
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
