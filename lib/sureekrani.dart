import 'dart:async';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin {
  bool _isCountingDown = false;
  bool _isPaused = false;
  Duration _remainingTime = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late DateTime _endTime;
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;
  int _minutes = 0;
  int _seconds = 0;
  Duration _totalSavedTime = Duration.zero;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _showTimeEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Süre Belirle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Dakika',
                ),
                onChanged: (value) {
                  setState(() {
                    _minutes = int.tryParse(value) ?? 0;
                  });
                },
                controller: TextEditingController(text: '$_minutes'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Saniye',
                ),
                onChanged: (value) {
                  setState(() {
                    _seconds = int.tryParse(value) ?? 0;
                  });
                },
                controller: TextEditingController(text: '$_seconds'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
                if (_isCountingDown) {
                  _resetTimer();
                } else {
                  _startTimer();
                }
              },
            ),
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startTimer() {
    final int totalSeconds = _minutes * 60 + _seconds;

    if (totalSeconds <= 0) return;

    setState(() {
      _isCountingDown = true;
      _remainingTime = Duration(seconds: totalSeconds);
      _totalDuration = Duration(seconds: totalSeconds);
      _endTime = DateTime.now().add(_remainingTime);
    });

    _animationController.duration = _remainingTime;
    _animationController.forward(from: 0.0);

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final now = DateTime.now();
      final difference = _endTime.difference(now);

      if (difference.isNegative) {
        _timer.cancel();
        setState(() {
          _isCountingDown = false;
          _remainingTime = Duration.zero;
          _elapsedTime += _totalDuration - Duration(seconds: difference.inSeconds);
          _saveTime();
        });
      } else {
        setState(() {
          _remainingTime = difference;
          _elapsedTime += Duration(milliseconds: 100);
          _animationController.value = (_totalDuration.inSeconds - _remainingTime.inSeconds) / _totalDuration.inSeconds;
        });
      }
    });
  }

  void _pauseTimer() {
    if (_isCountingDown) {
      _timer.cancel();
      setState(() {
        _isCountingDown = false;
        _isPaused = true;
        _elapsedTime += _remainingTime;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      setState(() {
        _isCountingDown = true;
        _isPaused = false;
        _endTime = DateTime.now().add(_remainingTime);
      });

      _animationController.duration = _remainingTime;
      _animationController.forward(from: _animationController.value);

      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        final now = DateTime.now();
        final difference = _endTime.difference(now);

        if (difference.isNegative) {
          _timer.cancel();
          setState(() {
            _isCountingDown = false;
            _remainingTime = Duration.zero;
            _elapsedTime += Duration(seconds: 1);
            _saveTime();
          });
        } else {
          setState(() {
            _remainingTime = difference;
            _elapsedTime += Duration(milliseconds: 100);
            _animationController.value = (_totalDuration.inSeconds - _remainingTime.inSeconds) / _totalDuration.inSeconds;
          });
        }
      });
    }
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isCountingDown = false;
      _isPaused = false;
      _remainingTime = Duration.zero;
      _elapsedTime = Duration.zero;
      _minutes = 0;
      _seconds = 0;
      _animationController.value = 0.0; // Reset animation
    });
  }

  void _saveTime() {
    setState(() {
      _totalSavedTime += _elapsedTime;
      _elapsedTime = Duration.zero;
    });
  }

  void _resetTotalSavedTime() {
    setState(() {
      _totalSavedTime = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zamanlayıcı Uygulaması'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _showTimeEditor(context),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(150.0, 150.0),
                      painter: ProgressPainter(
                        progress: _animationController.value,
                        color: Colors.purple,
                      ),
                    ),
                    Container(
                      width: 150.0,
                      height: 150.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300, // Açık gri renk
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _formatDuration(_remainingTime),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isCountingDown ? _pauseTimer : _resumeTimer,
                        child: Text(_isCountingDown ? 'Durdur' : 'Devam Et'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isCountingDown ? _saveTime : null,
                        child: Text('Süreyi Kaydet'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _resetTimer,
                        child: Text('Sıfırla'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _totalSavedTime > Duration.zero ? _resetTotalSavedTime : null,
                  child: Text('Toplam Süreyi Sıfırla'),
                ),
                SizedBox(height: 20),
                if (_totalSavedTime > Duration.zero)
                  Text(
                    'Toplam Kaydedilen Süre: ${_formatDuration(_totalSavedTime)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  ProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0 // Çubuğun kalınlığı
      ..strokeCap = StrokeCap.round;

    final Rect rect = Offset.zero & size;
    final double startAngle = -1.5 * 3.141592653589793; // -90 derece
    final double sweepAngle = 2 * 3.141592653589793 * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
