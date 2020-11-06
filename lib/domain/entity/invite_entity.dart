class InviteEntity {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerPhotoURL;
  final String title;
  final String detail;
  final String status;
  final List<dynamic> participants;

  InviteEntity({
    this.id,
    this.ownerId,
    this.ownerName,
    this.ownerPhotoURL,
    this.title,
    this.detail,
    this.status,
    this.participants,
  });

  factory InviteEntity.fromData(Map<String, dynamic> data, String dataId) {
    String status = "";
    bool isClosed = data["isClosed"];
    bool isOpen = data["isOpen"];
    if (isOpen) {
      if (isClosed) {
        // 参加
        status = "2";
      } else {
        // 募集中
        status = "1";
      }
    } else {
      if (isClosed) {
        // 締め切り
        status = "3";
      } else {
        // キャンセル
        status = "4";
      }
    }
    if (isClosed) {
      status = "締め切り";
    } else {
      status = "キャンセル";
    }

    return InviteEntity(
      id: dataId,
      ownerId: data["ownerId"],
      ownerName: data["ownerName"],
      ownerPhotoURL: data["ownerPhotoURL"],
      title: data["title"],
      detail: data["detail"],
      status: status,
      participants: data["usersInfo"],
    );
  }
}
