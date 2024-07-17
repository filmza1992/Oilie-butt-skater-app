class PostCreate {
  final String title;
  final String user_id;
  final int type;
  final String tag;
  final dynamic create_at;
  final dynamic content;

  PostCreate(
    this.title,
    this.user_id,
    this.type,
    this.tag,
    this.create_at,
    this.content,
  );
}
