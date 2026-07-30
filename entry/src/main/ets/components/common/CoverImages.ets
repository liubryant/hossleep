/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */

@Component
export struct SoundCoverImage {
  index: number = 1;
  directory: string = '';
  coverFile: string = 'cover.jpg';
  widthValue: Length = '100%';
  heightValue: Length = 156;
  radius: number = 8;

  build() {
    if (this.directory.length > 0) {
      this.cover(`resource://RAWFILE/SoundResources/${this.directory}/${this.coverFile}`)
    } else if (this.index === 1) {
      this.cover($rawfile('ios_sound_covers/sound_01.jpg'))
    } else if (this.index === 2) {
      this.cover($rawfile('ios_sound_covers/sound_02.jpg'))
    } else if (this.index === 3) {
      this.cover($rawfile('ios_sound_covers/sound_03.jpg'))
    } else if (this.index === 4) {
      this.cover($rawfile('ios_sound_covers/sound_04.jpg'))
    } else if (this.index === 5) {
      this.cover($rawfile('ios_sound_covers/sound_05.jpg'))
    } else if (this.index === 6) {
      this.cover($rawfile('ios_sound_covers/sound_06.jpg'))
    } else if (this.index === 7) {
      this.cover($rawfile('ios_sound_covers/sound_07.jpg'))
    } else if (this.index === 8) {
      this.cover($rawfile('ios_sound_covers/sound_08.jpg'))
    } else if (this.index === 9) {
      this.cover($rawfile('ios_sound_covers/sound_09.jpg'))
    } else if (this.index === 10) {
      this.cover($rawfile('ios_sound_covers/sound_10.jpg'))
    } else if (this.index === 11) {
      this.cover($rawfile('ios_sound_covers/sound_11.jpg'))
    } else if (this.index === 12) {
      this.cover($rawfile('ios_sound_covers/sound_12.jpg'))
    } else if (this.index === 13) {
      this.cover($rawfile('ios_sound_covers/sound_13.jpg'))
    } else if (this.index === 14) {
      this.cover($rawfile('ios_sound_covers/sound_14.jpg'))
    } else if (this.index === 15) {
      this.cover($rawfile('ios_sound_covers/sound_15.jpg'))
    } else if (this.index === 16) {
      this.cover($rawfile('ios_sound_covers/sound_16.jpg'))
    } else if (this.index === 17) {
      this.cover($rawfile('ios_sound_covers/sound_17.jpg'))
    } else if (this.index === 18) {
      this.cover($rawfile('ios_sound_covers/sound_18.jpg'))
    } else if (this.index === 19) {
      this.cover($rawfile('ios_sound_covers/sound_19.jpg'))
    } else {
      this.cover($rawfile('ios_sound_covers/sound_20.jpg'))
    }
  }

  @Builder
  private cover(source: ResourceStr) {
    Image(source)
      .width(this.widthValue)
      .height(this.heightValue)
      .objectFit(ImageFit.Cover)
      .borderRadius(this.radius)
      .clip(true)
  }
}

@Component
export struct StoryCoverImage {
  @Prop index: number = 1;
  @Prop coverFile: string = '';
  widthValue: Length = '100%';
  heightValue: Length = 128;
  radius: number = 10;

  build() {
    if (this.coverFile.length > 0) {
      this.cover(`resource://RAWFILE/${this.coverFile}`)
    } else if (this.index === 1) {
      this.cover($rawfile('ios_story_covers/story_01.jpg'))
    } else if (this.index === 2) {
      this.cover($rawfile('ios_story_covers/story_02.jpg'))
    } else if (this.index === 3) {
      this.cover($rawfile('ios_story_covers/story_03.jpg'))
    } else if (this.index === 4) {
      this.cover($rawfile('ios_story_covers/story_04.jpg'))
    } else if (this.index === 5) {
      this.cover($rawfile('ios_story_covers/story_05.jpg'))
    } else if (this.index === 6) {
      this.cover($rawfile('ios_story_covers/story_06.jpg'))
    } else if (this.index === 7) {
      this.cover($rawfile('ios_story_covers/story_07.jpg'))
    } else if (this.index === 8) {
      this.cover($rawfile('ios_story_covers/story_08.jpg'))
    } else if (this.index === 9) {
      this.cover($rawfile('ios_story_covers/story_09.jpg'))
    } else if (this.index === 10) {
      this.cover($rawfile('ios_story_covers/story_10.jpg'))
    } else if (this.index === 11) {
      this.cover($rawfile('ios_story_covers/story_11.jpg'))
    } else if (this.index === 12) {
      this.cover($rawfile('ios_story_covers/story_12.jpg'))
    } else if (this.index === 13) {
      this.cover($rawfile('ios_story_covers/story_13.jpg'))
    } else if (this.index === 14) {
      this.cover($rawfile('ios_story_covers/story_14.jpg'))
    } else if (this.index === 15) {
      this.cover($rawfile('ios_story_covers/story_15.jpg'))
    } else if (this.index === 16) {
      this.cover($rawfile('ios_story_covers/story_16.jpg'))
    } else if (this.index === 17) {
      this.cover($rawfile('ios_story_covers/story_17.jpg'))
    } else if (this.index === 18) {
      this.cover($rawfile('ios_story_covers/story_18.jpg'))
    } else if (this.index === 19) {
      this.cover($rawfile('ios_story_covers/story_19.jpg'))
    } else if (this.index === 20) {
      this.cover($rawfile('ios_story_covers/story_20.jpg'))
    } else if (this.index === 21) {
      this.cover($rawfile('ios_story_covers/story_21.jpg'))
    } else if (this.index === 22) {
      this.cover($rawfile('ios_story_covers/story_22.jpg'))
    } else if (this.index === 23) {
      this.cover($rawfile('ios_story_covers/story_23.jpg'))
    } else if (this.index === 24) {
      this.cover($rawfile('ios_story_covers/story_24.jpg'))
    } else if (this.index === 25) {
      this.cover($rawfile('ios_story_covers/story_25.jpg'))
    } else if (this.index === 26) {
      this.cover($rawfile('ios_story_covers/story_26.jpg'))
    } else if (this.index === 27) {
      this.cover($rawfile('ios_story_covers/story_27.jpg'))
    } else if (this.index === 28) {
      this.cover($rawfile('ios_story_covers/story_28.jpg'))
    } else if (this.index === 29) {
      this.cover($rawfile('ios_story_covers/story_29.jpg'))
    } else if (this.index === 30) {
      this.cover($rawfile('ios_story_covers/story_30.jpg'))
    } else if (this.index === 31) {
      this.cover($rawfile('ios_story_covers/story_31.jpg'))
    } else if (this.index === 32) {
      this.cover($rawfile('ios_story_covers/story_32.jpg'))
    } else if (this.index === 33) {
      this.cover($rawfile('ios_story_covers/story_33.jpg'))
    } else if (this.index === 34) {
      this.cover($rawfile('ios_story_covers/story_34.jpg'))
    } else if (this.index === 35) {
      this.cover($rawfile('ios_story_covers/story_35.jpg'))
    } else if (this.index === 36) {
      this.cover($rawfile('ios_story_covers/story_36.jpg'))
    } else if (this.index === 37) {
      this.cover($rawfile('ios_story_covers/story_37.jpg'))
    } else if (this.index === 38) {
      this.cover($rawfile('ios_story_covers/story_38.jpg'))
    } else if (this.index === 39) {
      this.cover($rawfile('ios_story_covers/story_39.jpg'))
    } else {
      this.cover($rawfile('ios_story_covers/story_40.jpg'))
    }
  }

  @Builder
  private cover(source: ResourceStr) {
    Image(source)
      .width(this.widthValue)
      .height(this.heightValue)
      .objectFit(ImageFit.Cover)
      .borderRadius(this.radius)
      .clip(true)
  }
}
