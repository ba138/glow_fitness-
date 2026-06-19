# Audio Setup Instructions

## How to Add Sound Effects to Your Fitness App

### Step 1: Prepare Your Audio Files

You need two audio files in MP3 format:
- `exercise_end.mp3` - A ring tone or notification sound (plays when each exercise ends)
- `workout_complete.mp3` - A celebratory/victory sound (plays when all exercises are finished)

### Step 2: Download or Create Sounds

Here are some resources for free sound effects:
- **Pixabay**: https://pixabay.com/sound-effects/
- **Zapsplat**: https://www.zapsplat.com/
- **Freesound**: https://freesound.org/
- **Online Tone Generator**: https://www.szynalski.com/tone-generator/

**Recommended sounds:**
- Exercise End: Simple bell ring, notification ping, or beep (2-3 seconds)
- Workout Complete: Triumphant fanfare, success chime, or victory bell (3-5 seconds)

### Step 3: Add Files to Your Project

1. Place the MP3 files in: `assets/sounds/`
   - `assets/sounds/exercise_end.mp3`
   - `assets/sounds/workout_complete.mp3`

2. Make sure your `pubspec.yaml` has the assets configured:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/sounds/
```

### Step 4: Run the App

```bash
flutter clean
flutter pub get
flutter run
```

## Testing

When you start a workout:
- Each time an exercise ends, you'll hear the `exercise_end.mp3` sound
- When all exercises are complete, you'll hear the `workout_complete.mp3` sound

## Troubleshooting

If sounds don't play:
1. Check that files are in the correct location
2. Verify the exact filename matches (case-sensitive)
3. Ensure files are in MP3 format
4. Run `flutter clean` and `flutter pub get`
5. Check console logs for error messages

## Converting Audio Files

If you have audio in a different format, you can convert it to MP3:
- **Online**: https://online-audio-converter.com/
- **ffmpeg**: `ffmpeg -i input.wav output.mp3`
- **Audacity**: Open and export as MP3
