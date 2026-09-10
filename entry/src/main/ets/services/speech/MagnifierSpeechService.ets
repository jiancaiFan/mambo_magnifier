export class MagnifierSpeechService {
  public async speak(text: string, rate: number): Promise<void> {
    console.info(`MagnifierSpeechService speak rate=${rate}, textLength=${text.length}`);
  }

  public async stop(): Promise<void> {
  }
}
