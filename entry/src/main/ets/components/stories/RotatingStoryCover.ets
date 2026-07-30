@Component
export struct RotatingStoryCover {
  @Prop index: number = 1;
  @Prop coverFile: string = '';
  @Prop isPlaying: boolean = false;
  @Prop diameter: number = 196;
  @State private rotation: number = 0;
  private rotationTimer: number = -1;

  aboutToAppear(): void {
    this.rotationTimer = setInterval(() => {
      if (this.isPlaying) {
        this.rotation = (this.rotation + 0.6) % 360;
      }
    }, 50);
  }

  aboutToDisappear(): void {
    if (this.rotationTimer >= 0) {
      clearInterval(this.rotationTimer);
      this.rotationTimer = -1;
    }
  }

  build() {
    Stack() {
      Column()
        .width(this.diameter)
        .height(this.diameter)
        .backgroundColor('#11000000')
        .borderRadius(this.diameter / 2)

      Stack() {
        Image(this.coverSource())
          .width(this.diameter - 20)
          .height(this.diameter - 20)
          .objectFit(ImageFit.Cover)
          .borderRadius((this.diameter - 20) / 2)
      }
      .width(this.diameter - 20)
      .height(this.diameter - 20)
      .borderRadius((this.diameter - 20) / 2)
      .clip(true)
      .rotate({ angle: this.isPlaying ? this.rotation : 0 })

      Column()
        .width(14)
        .height(14)
        .backgroundColor(Color.White)
        .borderRadius(7)
    }
    .width(this.diameter)
    .height(this.diameter)
    .borderRadius(this.diameter / 2)
    .clip(true)
  }

  private coverSource(): ResourceStr {
    if (this.coverFile.length > 0) {
      return `resource://RAWFILE/${this.coverFile}`;
    }
    const number = this.index < 10 ? `0${this.index}` : `${this.index}`;
    return `resource://RAWFILE/ios_story_covers/story_${number}.jpg`;
  }
}
