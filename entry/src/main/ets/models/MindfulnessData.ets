import { SoundSceneItem } from './SleepModels';

export interface MindfulnessItem {
  id: string;
  title: string;
  subtitle: string;
  cover: string;
  audio: string;
  colors: string[];
}

export interface MindfulnessBanner {
  title: string;
  detail: string;
  colors: string[];
}

export const MINDFULNESS_ITEMS: MindfulnessItem[] = [
  { id: 'deep-sleep', title: '深度睡眠疗愈', subtitle: '卸下疲惫，沉入安稳梦境', cover: 'mindfulness/covers/1.png', audio: 'mindfulness/audio/deep_sleep.mp3', colors: ['#294F57', '#3B686B'] },
  { id: 'daytime-energy', title: '日间提神', subtitle: '唤醒精神，找回清晰专注', cover: 'mindfulness/covers/2.png', audio: 'mindfulness/audio/daytime_energy.mp3', colors: ['#80562E', '#B88645'] },
  { id: 'walking', title: '散步冥想', subtitle: '跟随脚步，感受此时此地', cover: 'mindfulness/covers/3.png', audio: 'mindfulness/audio/walking.mp3', colors: ['#2E6145', '#568C64'] },
  { id: 'emotional-release', title: '睡前释放情绪', subtitle: '温柔放下今天的情绪', cover: 'mindfulness/covers/4.png', audio: 'mindfulness/audio/emotional_release.mp3', colors: ['#573D6E', '#826193'] },
  { id: 'calming-sleep', title: '安定身心助眠', subtitle: '舒缓呼吸，让身体松下来', cover: 'mindfulness/covers/5.png', audio: 'mindfulness/audio/calming_sleep.mp3', colors: ['#265763', '#47858C'] },
  { id: 'fatigue-relief', title: '缓解疲倦', subtitle: '短暂休息，恢复身心能量', cover: 'mindfulness/covers/6.png', audio: 'mindfulness/audio/fatigue_relief.mp3', colors: ['#405F42', '#73965A'] },
  { id: 'quick-sleep', title: '快速入睡', subtitle: '平静思绪，更快进入睡眠', cover: 'mindfulness/covers/7.png', audio: 'mindfulness/audio/quick_sleep.mp3', colors: ['#303D78', '#5264A3'] },
  { id: 'exam-sleep', title: '考前失眠解放', subtitle: '减少紧张，安心迎接明天', cover: 'mindfulness/covers/8.png', audio: 'mindfulness/audio/exam_sleep.mp3', colors: ['#6B3D5C', '#9E6382'] }
];

export const MINDFULNESS_BANNERS: MindfulnessBanner[] = [
  { title: '正念，是温柔地回到此刻', detail: '不评判此刻的感受，只是留意呼吸、身体与正在发生的一切。', colors: ['#1A575C', '#599484'] },
  { title: '从一次自然呼吸开始', detail: '找一个舒服的姿势，闭上眼睛，跟随声音，把注意力放在呼吸上。', colors: ['#40457A', '#7D7AB3'] },
  { title: '走神了，也完全没关系', detail: '发现思绪飘走时，不必责备自己，轻轻觉察，再慢慢回到当下。', colors: ['#6B4A33', '#B08257'] }
];

export function lastNatureScenes(scenes: SoundSceneItem[]): SoundSceneItem[] {
  return scenes.slice(Math.max(0, scenes.length - 20));
}

