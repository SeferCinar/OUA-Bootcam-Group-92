
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HabitScreen extends StatefulWidget {
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numericGoalController = TextEditingController();
  final TextEditingController _durationAmountController = TextEditingController();
  final TextEditingController _dailyFrequencyController = TextEditingController();
  final List<bool> _selectedDays = List.generate(7, (index) => false);

  String _durationUnit = "Gün";
  String _frequency = "Günlük";
  String _habitType = "Sayısal";
  String _visibility = "Herkese Açık";
  TimeOfDay _reminderTime = TimeOfDay.now();
  Color _selectedColor = Colors.blue;

  bool _isNumericInputVisible = true;
  bool _isDurationAmountVisible = true;
  bool _isDailyFrequencyVisible = false;
  bool _isWeeklyDaysVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _numericGoalController.dispose();
    _durationAmountController.dispose();
    _dailyFrequencyController.dispose();
    super.dispose();
  }

  void _createHabit() {
    // Your habit creation logic here
    Navigator.pop(context); // Close the screen after creating the habit
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _selectColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Renk Seçin'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alışkanlık Oluşturma'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'İsim',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Süre'),
              value: 'Gün',
              items: ['Gün', 'Ay'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _durationUnit = newValue!;
                  _isDurationAmountVisible = true;
                });
              },
            ),
            if (_isDurationAmountVisible)
              TextField(
                controller: _durationAmountController,
                decoration: InputDecoration(
                  labelText: 'Süre Miktarı ($_durationUnit)',
                  prefixIcon: Icon(Icons.access_time),
                ),
                keyboardType: TextInputType.number,
              ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Sıklığı'),
              value: 'Günlük',
              items: ['Günlük', 'Haftalık'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _frequency = newValue!;
                  _isDailyFrequencyVisible = _frequency == 'Günlük';
                  _isWeeklyDaysVisible = _frequency == 'Haftalık';
                });
              },
            ),
            if (_isDailyFrequencyVisible)
              TextField(
                controller: _dailyFrequencyController,
                decoration: InputDecoration(
                  labelText: 'Günde Kaç Defa',
                  prefixIcon: Icon(Icons.repeat),
                ),
                keyboardType: TextInputType.number,
              ),
            if (_isWeeklyDaysVisible)
              Wrap(
                spacing: 8.0,
                children: List<Widget>.generate(7, (int index) {
                  return FilterChip(
                    label: Text(
                      ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'][index],
                    ),
                    selected: _selectedDays[index],
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedDays[index] = selected;
                      });
                    },
                  );
                }).toList(),
              ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Alışkanlık Türü'),
              value: 'Sayısal',
              items: ['Sayısal', 'Süreli'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _habitType = newValue!;
                  _isNumericInputVisible = _habitType == 'Sayısal';
                });
              },
            ),
            if (_isNumericInputVisible)
              TextField(
                controller: _numericGoalController,
                decoration: InputDecoration(
                  labelText: 'Hedef (Sayı)',
                  prefixIcon: Icon(Icons.tag),
                ),
                keyboardType: TextInputType.number,
              ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gizlilik'),
              value: 'Herkese Açık',
              items: ['Özel', 'Herkese Açık'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _visibility = newValue!;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hatırlatıcı:', style: TextStyle(fontSize: 18)),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    _reminderTime.format(context),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Renk Seçimi:', style: TextStyle(fontSize: 18)),
                GestureDetector(
                  onTap: _selectColor,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _createHabit,
                child: Text('Oluştur'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
