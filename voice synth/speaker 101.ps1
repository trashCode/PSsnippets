Add-Type -AssemblyName System.Speech

$speaker = new-object System.speech.Synthesis.SpeechSynthesizer
$speaker.Rate = 0
$speaker.volume = 100
$null = $speaker.speakAsync('everything is going to be fine')

