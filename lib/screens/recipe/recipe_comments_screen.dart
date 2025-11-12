import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_image_widget.dart';

class RecipeCommentsScreen extends ConsumerStatefulWidget {
  final String recipeId;
  final String recipeTitle;
  final int recipeAuthorId;

  const RecipeCommentsScreen({
    Key? key,
    required this.recipeId,
    required this.recipeTitle,
    required this.recipeAuthorId,
  }) : super(key: key);

  @override
  ConsumerState<RecipeCommentsScreen> createState() => _RecipeCommentsScreenState();
}

class _RecipeCommentsScreenState extends ConsumerState<RecipeCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  int? _replyingToId;
  String? _replyingToName;

  // Mock data de comentários
  List<Comment> _comments = [
    Comment(
      id: 1,
      userId: 4,
      userName: 'Ana Beatriz Costa',
      userImage: 'assets/images/chef.jpg',
      text: 'Receita incrível! Fiz ontem e ficou perfeito. Minha família adorou! 😍',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      likes: 12,
      isLiked: true,
      replies: [
        Comment(
          id: 11,
          userId: 1,
          userName: 'João Pedro Silva',
          userImage: null,
          text: 'Muito obrigado pelo feedback! Fico feliz que tenha gostado! ❤️',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
          likes: 5,
          isLiked: false,
        ),
        Comment(
          id: 12,
          userId: 6,
          userName: 'Juliana Ferreira',
          userImage: null,
          text: 'Também fiz e aprovei! Deliciosa!',
          timestamp: DateTime.now().subtract(Duration(hours: 1)),
          likes: 3,
          isLiked: false,
        ),
      ],
    ),
    Comment(
      id: 2,
      userId: 10,
      userName: 'Fernanda Gomes',
      userImage: null,
      text: 'Posso substituir o leite de coco por leite comum?',
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      likes: 3,
      isLiked: false,
      replies: [
        Comment(
          id: 21,
          userId: 1,
          userName: 'João Pedro Silva',
          userImage: null,
          text: 'Sim! Pode usar leite comum sem problemas. O sabor fica um pouco diferente mas continua delicioso!',
          timestamp: DateTime.now().subtract(Duration(hours: 4)),
          likes: 2,
          isLiked: false,
        ),
      ],
    ),
    Comment(
      id: 3,
      userId: 6,
      userName: 'Juliana Ferreira',
      userImage: null,
      text: 'Maravilhosa! Já é a terceira vez que faço essa receita. Nunca falha! 🎉',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      likes: 8,
      isLiked: false,
    ),
    Comment(
      id: 4,
      userId: 1,
      userName: 'João Pedro Silva',
      userImage: null,
      text: 'Para quem quiser uma versão ainda mais saudável, podem usar açúcar de coco! Fica incrível também! 💚',
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      likes: 15,
      isLiked: false,
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    final currentUser = ref.read(currentUserDataProvider);
    if (currentUser == null) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: currentUser['id'] as int,
      userName: currentUser['name'],
      userImage: currentUser['profileImage'],
      text: _commentController.text.trim(),
      timestamp: DateTime.now(),
      likes: 0,
      isLiked: false,
    );

    setState(() {
      if (_replyingToId != null) {
        // Adicionar resposta
        final commentIndex = _comments.indexWhere((c) => c.id == _replyingToId);
        if (commentIndex != -1) {
          _comments[commentIndex].replies.add(newComment);
        }
      } else {
        // Adicionar comentário principal
        _comments.insert(0, newComment);
      }
      _commentController.clear();
      _replyingToId = null;
      _replyingToName = null;
    });

    _commentFocusNode.unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              _replyingToId != null ? 'Resposta enviada!' : 'Comentário enviado!',
              style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Color(0xFF7CB342),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleLike(Comment comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      comment.likes += comment.isLiked ? 1 : -1;
    });
  }

  void _replyToComment(int commentId, String userName) {
    setState(() {
      _replyingToId = commentId;
      _replyingToName = userName;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comentários',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF3C4D18),
              ),
            ),
            Text(
              widget.recipeTitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Color(0xFF999999),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de comentários
          Expanded(
            child: _comments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _buildCommentItem(
                  _comments[index],
                  currentUserId,
                  isReply: false,
                );
              },
            ),
          ),

          // Campo de input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Nenhum comentário ainda',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF666666),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Seja o primeiro a comentar!',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment, int? currentUserId, {required bool isReply}) {
    final bool isAuthor = comment.userId == widget.recipeAuthorId;
    final bool isCurrentUser = comment.userId == currentUserId;

    return Container(
      margin: EdgeInsets.only(
        bottom: 12,
        left: isReply ? 40 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ProfileImageWidget(
                userData: {'profileImage': comment.userImage},
                radius: isReply ? 16 : 20,
              ),
              SizedBox(width: 12),

              // Conteúdo do comentário
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome e badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              comment.userName,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: isReply ? 13 : 14,
                                color: Color(0xFF3C4D18),
                              ),
                            ),
                          ),
                          if (isAuthor)
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFA9500), Color(0xFFFF6B35)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 10),
                                  SizedBox(width: 4),
                                  Text(
                                    'AUTOR',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Texto do comentário
                      Text(
                        comment.text,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: isReply ? 13 : 14,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Ações (curtir, responder, tempo)
                      Row(
                        children: [
                          Text(
                            _formatTimestamp(comment.timestamp),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                          ),
                          if (comment.likes > 0) ...[
                            SizedBox(width: 12),
                            Text(
                              '${comment.likes} ${comment.likes == 1 ? 'curtida' : 'curtidas'}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFA9500),
                              ),
                            ),
                          ],
                          if (!isReply) ...[
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => _replyToComment(comment.id, comment.userName),
                              child: Text(
                                'Responder',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF7CB342),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Botão de curtir
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleLike(comment),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    comment.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: comment.isLiked ? Colors.red : Color(0xFF999999),
                    size: isReply ? 18 : 20,
                  ),
                ),
              ),
            ],
          ),

          // Respostas
          if (!isReply && comment.replies.isNotEmpty) ...[
            SizedBox(height: 8),
            ...comment.replies.map((reply) => _buildCommentItem(
              reply,
              currentUserId,
              isReply: true,
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner de resposta
            if (_replyingToId != null)
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.reply, color: Color(0xFFFA9500), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Respondendo $_replyingToName',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _cancelReply,
                      child: Icon(Icons.close, color: Color(0xFF999999), size: 18),
                    ),
                  ],
                ),
              ),

            // Campo de texto
            Row(
              children: [
                ProfileImageWidget(
                  userData: ref.watch(currentUserDataProvider),
                  radius: 18,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _commentController,
                      focusNode: _commentFocusNode,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Color(0xFF3C4D18),
                      ),
                      decoration: InputDecoration(
                        hintText: _replyingToId != null
                            ? 'Escreva sua resposta...'
                            : 'Adicione um comentário...',
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFA9500), Color(0xFFFF6B35)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFA9500).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class Comment {
  final int id;
  final int userId;
  final String userName;
  final String? userImage;
  final String text;
  final DateTime timestamp;
  int likes;
  bool isLiked;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.text,
    required this.timestamp,
    required this.likes,
    required this.isLiked,
    List<Comment>? replies,
  }) : this.replies = replies ?? [];
}