/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */

export interface SoundSceneItem {
  id: string;
  index: number;
  directory?: string;
  title: string;
  subtitle: string;
  category: string;
  coverFile?: string;
  audioFile?: string;
  isBundledAudio: boolean;
}

export interface StoryListItem {
  id: string;
  index: number;
  title: string;
  author?: string;
  durationText: string;
  summary?: string;
  sourceUrl?: string;
  coverFile?: string;
  textFile?: string;
  isBundled: boolean;
}

export interface SleepEventSummaryItem {
  title: string;
  symbol: string;
  count: number;
}

export interface ProfileRowItem {
  title: string;
  value: string;
  action: string;
  destructive?: boolean;
}
