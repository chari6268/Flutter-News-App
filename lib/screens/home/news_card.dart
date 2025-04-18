import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home/comments_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatefulWidget {
  final NewsModel news;
  final VoidCallback onAudioComplete;

  const NewsCard({
    Key? key,
    required this.news,
    required this.onAudioComplete,
  }) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _playAudio();
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      widget.onAudioComplete();
    });
  }

  void _playAudio() async {
    await _audioPlayer.play(UrlSource(widget.news.audioUrl));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final newsProvider = Provider.of<NewsProvider>(context);
    
    final String userId = authProvider.currentUser?.id ?? '';
    final bool isLiked = widget.news.likedBy.contains(userId);
    final bool isSaved = widget.news.savedBy.contains(userId);

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              widget.news.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ),
          // Category and Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.news.category,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(widget.news.postedDate),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.news.title,
              style: Theme.of(context).textTheme.headline6,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.news.content,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Audio Player
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.resume();
                    }
                  },
                ),
                Expanded(
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    min: 0,
                    max: _duration.inSeconds.toDouble() + 1,
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Text(
                  '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Like button
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    newsProvider.toggleLikeNews(widget.news.id, !isLiked);
                  },
                ),
                // Comment button
                IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(newsId: widget.news.id),
                      ),
                    );
                  },
                ),
                // Share button
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                      'Check out this news: ${widget.news.title} - ${widget.news.content.substring(0, min(50, widget.news.content.length))}...',
                    );
                  },
                ),
                // Save button
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Theme.of(context).primaryColor : null,
                  ),
                  onPressed: () {
                    newsProvider.toggleSaveNews(widget.news.id, !isSaved);
                  },
                ),
                // Report button
                IconButton(
                  icon: Icon(Icons.flag_outlined),
                  onPressed: () {
                    _showReportDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    String reason = 'Vulgar Content';
    String comment = '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report News'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Reason:'),
                RadioListTile<String>(
                  title: Text('Vulgar Content'),
                  value: 'Vulgar Content',
                  groupValue: reason,
                  onChanged: (value) {
                    setState(() {
                      reason = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Fake/Misleading'),
                  value: 'Fake/Misleading',
                  groupValue: reason,
                  onChanged: (value) {
                    setState(() {
                      reason = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Biased'),
                  value: 'Biased',
                  groupValue: reason,
                  onChanged: (value) {
                    setState(() {
                      reason = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Deepfake content'),
                  value: 'Deepfake content',
                  groupValue: reason,
                  onChanged: (value) {
                    setState(() {
                      reason = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Additional Comments',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    comment = value;
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newsProvider = Provider.of<NewsProvider>(context, listen: false);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              
              final userId = authProvider.currentUser?.id ?? '';
              newsProvider.reportNews(
                widget.news.id, 
                userId, 
                reason, 
                comment,
              );
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Report submitted successfully')),
              );
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
  
  int min(int a, int b) => a < b ? a : b;
}