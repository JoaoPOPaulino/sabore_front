class User {
  final int id;
  final String username;
  final String email;
  final String? name;
  final String? location;
  final String? profileImage;
  final String? bio;
  final String? phone;
  final int recipesCount;
  final int followersCount;
  final int followingCount;
  final double? averageRating;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.location,
    this.profileImage,
    this.bio,
    this.phone,
    this.recipesCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.averageRating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      location: json['location'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      phone: json['phone'],
      recipesCount: json['recipes_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      averageRating: json['average_rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'location': location,
      'profile_image': profileImage,
      'bio': bio,
      'phone': phone,
    };
  }
}

class Recipe {
  final int id;
  final String title;
  final String description;
  final String? image;
  final int preparationTime;
  final int servings;
  final List<String> ingredients;
  final List<String> steps;
  final String? category;
  final int userId;
  final String? userName;
  final String? userImage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final double? averageRating;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.preparationTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    this.category,
    required this.userId,
    this.userName,
    this.userImage,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.averageRating,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      preparationTime: json['preparation_time'],
      servings: json['servings'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      category: json['category'],
      userId: json['user_id'] ?? json['user']?['id'],
      userName: json['user_name'] ?? json['user']?['name'],
      userImage: json['user_image'] ?? json['user']?['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
      averageRating: json['average_rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'preparation_time': preparationTime,
      'servings': servings,
      'ingredients': ingredients,
      'steps': steps,
      'category': category,
    };
  }

  Recipe copyWith({
    int? id,
    String? title,
    String? description,
    String? image,
    int? preparationTime,
    int? servings,
    List<String>? ingredients,
    List<String>? steps,
    String? category,
    bool? isLiked,
    bool? isSaved,
    int? likesCount,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      preparationTime: preparationTime ?? this.preparationTime,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      category: category ?? this.category,
      userId: this.userId,
      userName: this.userName,
      userImage: this.userImage,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      averageRating: this.averageRating,
    );
  }
}

class RecipeBook {
  final int id;
  final String title;
  final String? description;
  final int recipesCount;
  final String? coverImage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RecipeBook({
    required this.id,
    required this.title,
    this.description,
    this.recipesCount = 0,
    this.coverImage,
    required this.createdAt,
    this.updatedAt,
  });

  factory RecipeBook.fromJson(Map<String, dynamic> json) {
    return RecipeBook(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      recipesCount: json['recipes_count'] ?? 0,
      coverImage: json['cover_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class Review {
  final int id;
  final int recipeId;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String comment;
  final String? image;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.image,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      userName: json['user_name'] ?? json['user']?['name'] ?? 'Usuário',
      userAvatar: json['user_avatar'] ?? json['user']?['profile_image'],
      rating: json['rating'],
      comment: json['comment'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipe_id': recipeId,
      'rating': rating,
      'comment': comment,
      'image': image,
    };
  }
}

class Category {
  final int id;
  final String name;
  final String? icon;
  final int recipesCount;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.recipesCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      recipesCount: json['recipes_count'] ?? 0,
    );
  }
}