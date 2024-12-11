enum Phase { Day, Night }

class GamePhase {
  Phase currentPhase = Phase.Day;

  void switchPhase() {
    currentPhase = currentPhase == Phase.Day ? Phase.Night : Phase.Day;
  }
}
