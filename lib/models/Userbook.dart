// To parse this JSON data, do
//
//     final userbook = userbookFromJson(jsonString);

import 'dart:convert';

List<Userbook> userbookFromJson(String str) => List<Userbook>.from(json.decode(str).map((x) => Userbook.fromJson(x)));

String userbookToJson(List<Userbook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Userbook {
    String model;
    int pk;
    Fields fields;

    Userbook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Userbook.fromJson(Map<String, dynamic> json) => Userbook(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String isbn;
    String title;
    String author;
    int year;
    String publisher;
    String imageS;
    String imageM;
    String imageL;

    Fields({
        required this.isbn,
        required this.title,
        required this.author,
        required this.year,
        required this.publisher,
        required this.imageS,
        required this.imageM,
        required this.imageL,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        year: json["year"],
        publisher: json["publisher"],
        imageS: json["image_s"],
        imageM: json["image_m"],
        imageL: json["image_l"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "author": author,
        "year": year,
        "publisher": publisher,
        "image_s": imageS,
        "image_m": imageM,
        "image_l": imageL,
    };
}
