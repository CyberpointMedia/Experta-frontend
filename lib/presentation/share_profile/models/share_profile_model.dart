class ShareProfile {
    final String status;
    final Data data;

    ShareProfile({
        required this.status,
        required this.data,
    });

}

class Data {
    final String qrCode;
    final ProfileData profileData;

    Data({
        required this.qrCode,
        required this.profileData,
    });

}

class ProfileData {
    final String id;
    final String name;
    final String title;

    ProfileData({
        required this.id,
        required this.name,
        required this.title,
    });

}
