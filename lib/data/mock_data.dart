class FoodMenuItem {
  final String id;
  final String name;
  final String description;
  final int pricePkr;
  final String category;
  final String imageUrl;
  final bool isVeg;

  FoodMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePkr,
    required this.category,
    required this.imageUrl,
    this.isVeg = true,
  });
}

class UpcomingEvent {
  final String id;
  final String title;
  final String subtitle;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final Duration repeatEvery;
  final String thumbnailAsset;

  UpcomingEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.repeatEvery,
    required this.thumbnailAsset,
  });

  UpcomingEvent rollForward(DateTime now) {
    if (!now.isAfter(endAt)) return this;

    final delta = now.difference(endAt);
    final k = (delta.inSeconds / repeatEvery.inSeconds).floor() + 1;
    final shift = Duration(seconds: repeatEvery.inSeconds * k);

    return UpcomingEvent(
      id: id,
      title: title,
      subtitle: subtitle,
      location: location,
      startAt: startAt.add(shift),
      endAt: endAt.add(shift),
      repeatEvery: repeatEvery,
      thumbnailAsset: thumbnailAsset,
    );
  }
}

class PodcastEpisode {
  final String id;
  final String topicTitle;
  final String category;
  final String hostName;
  final String guestName;
  final int durationMinutes;
  final DateTime scheduledAt;
  final Duration repeatEvery;
  final String hostImageAsset;
  final String topicThumbnailAsset;

  PodcastEpisode({
    required this.id,
    required this.topicTitle,
    required this.category,
    required this.hostName,
    required this.guestName,
    required this.durationMinutes,
    required this.scheduledAt,
    required this.repeatEvery,
    required this.hostImageAsset,
    required this.topicThumbnailAsset,
  });

  PodcastEpisode rollForward(DateTime now) {
    if (!now.isAfter(scheduledAt)) return this;

    final delta = now.difference(scheduledAt);
    final k = (delta.inSeconds / repeatEvery.inSeconds).floor() + 1;
    final shift = Duration(seconds: repeatEvery.inSeconds * k);

    return PodcastEpisode(
      id: id,
      topicTitle: topicTitle,
      category: category,
      hostName: hostName,
      guestName: guestName,
      durationMinutes: durationMinutes,
      scheduledAt: scheduledAt.add(shift),
      repeatEvery: repeatEvery,
      hostImageAsset: hostImageAsset,
      topicThumbnailAsset: topicThumbnailAsset,
    );
  }
}

class JobPost {
  final String id;
  final String title;
  final String company;
  final String location;
  final String payText;
  final String description;

  JobPost({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.payText,
    required this.description,
  });
}

class RewardItem {
  final String id;
  final String title;
  final String tier;
  final String benefit;
  final int pointsRequired;

  RewardItem({
    required this.id,
    required this.title,
    required this.tier,
    required this.benefit,
    required this.pointsRequired,
  });
}

class LeaderboardEntry {
  final String id;
  final String name;
  final String avatarAsset;
  final int points;
  final String achievement;

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.avatarAsset,
    required this.points,
    required this.achievement,
  });
}

class BlogPost {
  final String id;
  final String title;
  final String author;
  final String excerpt;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.author,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
  });
}

class MockData {
  static List<FoodMenuItem> foodMenu = [
    FoodMenuItem(
      id: '1',
      name: 'Chicken Biryani',
      description: 'Fragrant basmati rice with spiced chicken and herbs',
      pricePkr: 280,
      category: 'Main',
      imageUrl: 'assets/images/biryani.jpg',
      isVeg: false,
    ),
    FoodMenuItem(
      id: '2',
      name: 'Seekh Kabab Roll',
      description: 'Grilled skewers wrapped in fresh paratha with chutney',
      pricePkr: 150,
      category: 'Snack',
      imageUrl: 'assets/images/kabab_roll.jpg',
      isVeg: false,
    ),
    FoodMenuItem(
      id: '3',
      name: 'Daal Chawal',
      description: 'Classic lentil curry with steamed rice',
      pricePkr: 120,
      category: 'Main',
      imageUrl: 'assets/images/daal_chawal.jpg',
      isVeg: true,
    ),
    FoodMenuItem(
      id: '4',
      name: 'Samosa (2 pcs)',
      description: 'Crispy pastry filled with spiced potatoes and peas',
      pricePkr: 60,
      category: 'Snack',
      imageUrl: 'assets/images/samosa.jpg',
      isVeg: true,
    ),
    FoodMenuItem(
      id: '5',
      name: 'Chicken Karahi',
      description: 'Spicy chicken curry cooked in a traditional wok',
      pricePkr: 450,
      category: 'Main',
      imageUrl: 'assets/images/karahi.jpg',
      isVeg: false,
    ),
    FoodMenuItem(
      id: '6',
      name: 'Aloo Paratha',
      description: 'Flaky flatbread stuffed with seasoned potatoes',
      pricePkr: 80,
      category: 'Snack',
      imageUrl: 'assets/images/aloo_paratha.jpg',
      isVeg: true,
    ),
  ];

  static List<JobPost> jobs = [
    JobPost(
      id: 'j1',
      title: 'Campus Ambassador',
      company: 'TechConnect',
      location: 'On-site',
      payText: 'Rs 8,000/mo',
      description: 'Promote tech events and workshops on campus.',
    ),
    JobPost(
      id: 'j2',
      title: 'Content Writer',
      company: 'BlogPak',
      location: 'Remote',
      payText: 'Rs 15,000/mo',
      description: 'Write articles about student life and tech trends.',
    ),
    JobPost(
      id: 'j3',
      title: 'Lab Assistant',
      company: 'CS Department',
      location: 'Lab 301',
      payText: 'Rs 10,000/mo',
      description: 'Help maintain labs and assist students during sessions.',
    ),
  ];

  static List<RewardItem> rewards = [
    RewardItem(
      id: 'r1',
      title: 'Free Coffee',
      tier: 'Bronze',
      benefit: 'Claim at campus café',
      pointsRequired: 100,
    ),
    RewardItem(
      id: 'r2',
      title: 'Library Voucher',
      tier: 'Silver',
      benefit: 'Rs 200 off books',
      pointsRequired: 300,
    ),
    RewardItem(
      id: 'r3',
      title: 'Event Pass',
      tier: 'Gold',
      benefit: 'Free entry to all events',
      pointsRequired: 800,
    ),
  ];

  static List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(
      id: 'lb1',
      name: 'Ayesha Khan',
      avatarAsset: 'assets/images/host_ayesha.jpg',
      points: 950,
      achievement: 'Top Attendee',
    ),
    LeaderboardEntry(
      id: 'lb2',
      name: 'Bilal Ahmed',
      avatarAsset: 'assets/images/host_usman.jpg',
      points: 820,
      achievement: 'Quiz Master',
    ),
    LeaderboardEntry(
      id: 'lb3',
      name: 'Sara Nadeem',
      avatarAsset: 'assets/images/host_hira.jpg',
      points: 760,
      achievement: 'Helper Hero',
    ),
    LeaderboardEntry(
      id: 'lb4',
      name: 'Usman Tariq',
      avatarAsset: 'assets/images/host_usman.jpg',
      points: 680,
      achievement: 'Rising Star',
    ),
    LeaderboardEntry(
      id: 'lb5',
      name: 'Hina Raza',
      avatarAsset: 'assets/images/host_hira.jpg',
      points: 590,
      achievement: 'Team Player',
    ),
  ];

  static List<BlogPost> blogs = [
    BlogPost(
      id: 'b1',
      title: 'Top Study Spots on Campus',
      author: 'Ayesha Khan',
      excerpt: 'Discover quiet and inspiring places to ace your exams.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/topstudy_spots.jpg',
      publishedAt: DateTime(2026, 1, 10),
    ),
    BlogPost(
      id: 'b2',
      title: 'How to Balance Part-time Work and Studies',
      author: 'Bilal Ahmed',
      excerpt: 'Tips from seniors who\'ve been there.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/balance_job_studies.jpg',
      publishedAt: DateTime(2026, 1, 8),
    ),
    BlogPost(
      id: 'b3',
      title: 'Student Discounts Guide 2026',
      author: 'Sara Nadeem',
      excerpt: 'Save money with these verified deals.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/blog_discounts.jpg',
      publishedAt: DateTime(2026, 1, 5),
    ),
    BlogPost(
      id: 'b4',
      title: 'Internship Hunting in Pakistan',
      author: 'Usman Tariq',
      excerpt: 'Where to look and how to apply for tech internships.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/internship_in_pk.jpg',
      publishedAt: DateTime(2026, 1, 3),
    ),
    BlogPost(
      id: 'b5',
      title: 'Exam Survival Kit',
      author: 'Hina Raza',
      excerpt: 'Essential tools and techniques for finals week.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/examination_survival.jpg',
      publishedAt: DateTime(2025, 12, 28),
    ),
    BlogPost(
      id: 'b6',
      title: 'Campus Food Review',
      author: 'Zain Ali',
      excerpt: 'Rating the best and worst dishes at our cafeteria.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/birani_vs_karahi.jpg',
      publishedAt: DateTime(2025, 12, 25),
    ),
    BlogPost(
      id: 'b7',
      title: 'Building Your First App',
      author: 'Ayesha Khan',
      excerpt: 'A beginner\'s guide to mobile development.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/food_delivery.jpg',
      publishedAt: DateTime(2025, 12, 20),
    ),
    BlogPost(
      id: 'b8',
      title: 'Time Management for Students',
      author: 'Bilal Ahmed',
      excerpt: 'Strategies to juggle assignments, exams, and social life.',
      content: 'Full article content here...',
      imageUrl: 'assets/images/rewards.jpg',
      publishedAt: DateTime(2025, 12, 15),
    ),
  ];

  static List<UpcomingEvent> upcomingEvents = [
    UpcomingEvent(
      id: 'e1',
      title: 'Rewards Deadline',
      subtitle: 'Claim attendance perks before they reset.',
      location: 'Student Portal',
      startAt: DateTime(2026, 1, 19, 18, 0),
      endAt: DateTime(2026, 1, 19, 21, 0),
      repeatEvery: Duration(days: 7),
      thumbnailAsset: 'assets/images/examination_survival.jpg',
    ),
    UpcomingEvent(
      id: 'e2',
      title: 'Career Office Drop-in',
      subtitle: 'CV review + internship guidance.',
      location: 'Admin Block - Room 12',
      startAt: DateTime(2026, 1, 20, 11, 0),
      endAt: DateTime(2026, 1, 20, 13, 0),
      repeatEvery: Duration(days: 7),
      thumbnailAsset: 'assets/images/internship_in_pk.jpg',
    ),
    UpcomingEvent(
      id: 'e3',
      title: 'Podcast Recording (Live)',
      subtitle: 'Student stories & campus hacks.',
      location: 'Media Lab',
      startAt: DateTime(2026, 1, 21, 16, 0),
      endAt: DateTime(2026, 1, 21, 17, 0),
      repeatEvery: Duration(days: 14),
      thumbnailAsset: 'assets/images/birani_vs_karahi.jpg',
    ),
  ];

  static List<PodcastEpisode> podcasts = [
    PodcastEpisode(
      id: 'p1',
      topicTitle: 'How to Survive Finals Week (Without Burning Out)',
      category: 'Student Life',
      hostName: 'Ayesha',
      guestName: 'Bilal',
      durationMinutes: 28,
      scheduledAt: DateTime(2026, 1, 20, 19, 0),
      repeatEvery: Duration(days: 7),
      hostImageAsset: 'assets/images/host_ayesha.jpg',
      topicThumbnailAsset: 'assets/images/examination_survival.jpg',
    ),
    PodcastEpisode(
      id: 'p2',
      topicTitle: 'Getting Your First Internship in Pakistan',
      category: 'Career',
      hostName: 'Usman',
      guestName: 'Sara',
      durationMinutes: 34,
      scheduledAt: DateTime(2026, 1, 22, 20, 30),
      repeatEvery: Duration(days: 14),
      hostImageAsset: 'assets/images/host_usman.jpg',
      topicThumbnailAsset: 'assets/images/internship_in_pk.jpg',
    ),
    PodcastEpisode(
      id: 'p3',
      topicTitle: 'Campus Food Tier List: Biryani vs Karahi',
      category: 'Fun',
      hostName: 'Hira',
      guestName: 'Zain',
      durationMinutes: 22,
      scheduledAt: DateTime(2026, 1, 24, 18, 0),
      repeatEvery: Duration(days: 7),
      hostImageAsset: 'assets/images/host_hira.jpg',
      topicThumbnailAsset: 'assets/images/birani_vs_karahi.jpg',
    ),
  ];
}
