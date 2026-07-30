/**
 * @author liuzheng
 * @mail bryant_liu24@126.com
 */
import { ProfileRowItem, SleepEventSummaryItem, SoundSceneItem, StoryListItem } from './SleepModels';

export const SOUND_CATEGORIES: string[] = ['全部', '推荐', '收藏', '冥想', '助眠', '自然', '耳畔', '白噪音', '梦境', '正念'];

export const SOUND_SCENES: SoundSceneItem[] = [
  { id: 'sound-001', index: 1, title: '夏威夷海滩', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-002', index: 2, title: '悠长假日', subtitle: '助眠声音', category: '梦境', isBundledAudio: true },
  { id: 'sound-003', index: 3, title: '声音浴', subtitle: '助眠声音', category: '冥想', isBundledAudio: true },
  { id: 'sound-004', index: 4, title: '四天王寺', subtitle: '助眠声音', category: '正念', isBundledAudio: true },
  { id: 'sound-005', index: 5, title: '千岛湖', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-006', index: 6, title: '假日', subtitle: '助眠声音', category: '梦境', isBundledAudio: true },
  { id: 'sound-007', index: 7, title: '26.5℃', subtitle: '助眠声音', category: '助眠', isBundledAudio: true },
  { id: 'sound-008', index: 8, title: '西餐厅', subtitle: '助眠声音', category: '耳畔', isBundledAudio: true },
  { id: 'sound-009', index: 9, title: '猫的午后', subtitle: '助眠声音', category: '耳畔', isBundledAudio: true },
  { id: 'sound-010', index: 10, title: '热带雨林', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-011', index: 11, title: '春雨', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-012', index: 12, title: '须臾', subtitle: '助眠声音', category: '梦境', isBundledAudio: true },
  { id: 'sound-013', index: 13, title: '樱花', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-014', index: 14, title: '轴韵', subtitle: '助眠声音', category: '白噪音', isBundledAudio: true },
  { id: 'sound-015', index: 15, title: '远山', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-016', index: 16, title: '古镇清晨', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-017', index: 17, title: '磨砚', subtitle: '助眠声音', category: '正念', isBundledAudio: true },
  { id: 'sound-018', index: 18, title: '山泉', subtitle: '助眠声音', category: '自然', isBundledAudio: true },
  { id: 'sound-019', index: 19, title: '蒲公英', subtitle: '助眠声音', category: '梦境', isBundledAudio: true },
  { id: 'sound-020', index: 20, title: '冥想', subtitle: '助眠声音', category: '冥想', isBundledAudio: true }
];

export const STORY_ITEMS: StoryListItem[] = [
  { id: 'story-001', index: 1, title: '龙舟少年', durationText: '免费朗读', isBundled: true },
  { id: 'story-002', index: 2, title: '小萝卜与大萝卜', durationText: '免费朗读', isBundled: true },
  { id: 'story-003', index: 3, title: '怪兽餐厅', durationText: '免费朗读', isBundled: true },
  { id: 'story-004', index: 4, title: '没人愿意借她笔', durationText: '免费朗读', isBundled: true },
  { id: 'story-005', index: 5, title: '两片小叶子', durationText: '免费朗读', isBundled: true },
  { id: 'story-006', index: 6, title: '地球保卫战', durationText: '免费朗读', isBundled: true },
  { id: 'story-007', index: 7, title: '小猫学会过马路', durationText: '免费朗读', isBundled: true },
  { id: 'story-008', index: 8, title: '幸福便当', durationText: '免费朗读', isBundled: true },
  { id: 'story-009', index: 9, title: '千里寻药', durationText: '免费朗读', isBundled: true },
  { id: 'story-010', index: 10, title: '小海狸波波的新本领', durationText: '免费朗读', isBundled: true },
  { id: 'story-011', index: 11, title: '弟弟被抓走了！', durationText: '免费朗读', isBundled: true },
  { id: 'story-012', index: 12, title: '小作家', durationText: '免费朗读', isBundled: true },
  { id: 'story-013', index: 13, title: '弟弟消失了', durationText: '免费朗读', isBundled: true },
  { id: 'story-014', index: 14, title: '最棒的暴龙', durationText: '免费朗读', isBundled: true },
  { id: 'story-015', index: 15, title: '会发电的小台风', durationText: '免费朗读', isBundled: true },
  { id: 'story-016', index: 16, title: '变懒的机器人', durationText: '免费朗读', isBundled: true },
  { id: 'story-017', index: 17, title: '飞到月亮的布娃娃', durationText: '免费朗读', isBundled: true },
  { id: 'story-018', index: 18, title: '宁静山', durationText: '免费朗读', isBundled: true },
  { id: 'story-019', index: 19, title: '被偷走的坚果', durationText: '免费朗读', isBundled: true },
  { id: 'story-020', index: 20, title: '蜜蜂爸爸生病了', durationText: '免费朗读', isBundled: true },
  { id: 'story-021', index: 21, title: '种出自己的松果树', durationText: '免费朗读', isBundled: true },
  { id: 'story-022', index: 22, title: '虎王的继承者', durationText: '免费朗读', isBundled: true },
  { id: 'story-023', index: 23, title: '狮王报恩', durationText: '免费朗读', isBundled: true },
  { id: 'story-024', index: 24, title: '蔬菜小超人', durationText: '免费朗读', isBundled: true },
  { id: 'story-025', index: 25, title: '橡皮擦的功劳', durationText: '免费朗读', isBundled: true },
  { id: 'story-026', index: 26, title: '乌龟巴士', durationText: '免费朗读', isBundled: true },
  { id: 'story-027', index: 27, title: '黑猫队长', durationText: '免费朗读', isBundled: true },
  { id: 'story-028', index: 28, title: '勇敢说出来', durationText: '免费朗读', isBundled: true },
  { id: 'story-029', index: 29, title: '爸爸的爱藏在哪里？', durationText: '免费朗读', isBundled: true },
  { id: 'story-030', index: 30, title: '为什么朋友都不见了？', durationText: '免费朗读', isBundled: true },
  { id: 'story-031', index: 31, title: '不再迟到的小猪', durationText: '免费朗读', isBundled: true },
  { id: 'story-032', index: 32, title: '不想做兔子的豆豆', durationText: '免费朗读', isBundled: true },
  { id: 'story-033', index: 33, title: '被遗忘的生日', durationText: '免费朗读', isBundled: true },
  { id: 'story-034', index: 34, title: '爱说谎的的小松鼠', durationText: '免费朗读', isBundled: true },
  { id: 'story-035', index: 35, title: '没礼貌的小刺蝟', durationText: '免费朗读', isBundled: true },
  { id: 'story-036', index: 36, title: '我不要爸爸', durationText: '免费朗读', isBundled: true },
  { id: 'story-037', index: 37, title: '来不及说再见', durationText: '免费朗读', isBundled: true },
  { id: 'story-038', index: 38, title: '黑色兔子', durationText: '免费朗读', isBundled: true },
  { id: 'story-039', index: 39, title: '女孩一样能做到', durationText: '免费朗读', isBundled: true },
  { id: 'story-040', index: 40, title: '自己也能玩得很开心', durationText: '免费朗读', isBundled: true }
];

export const SLEEP_EVENTS: SleepEventSummaryItem[] = [
  { title: '打鼾咳嗽', symbol: 'waveform.path.ecg', count: 2 },
  { title: '说梦话', symbol: 'message.fill', count: 0 },
  { title: '磨牙', symbol: 'circle.grid.cross.fill', count: 1 },
  { title: '环境噪音', symbol: 'speaker.wave.2.fill', count: 4 }
];

export const PROFILE_PERMISSION_ROWS: ProfileRowItem[] = [
  { title: '麦克风', value: '使用时申请', action: '' }
];

export const PROFILE_DATA_ROWS: ProfileRowItem[] = [
  { title: '数据大小', value: '12.6 MB', action: '' },
  { title: '清除数据', value: '', action: 'clearData', destructive: true }
];

export const PROFILE_ABOUT_ROWS: ProfileRowItem[] = [
  { title: '用户协议', value: '', action: 'userAgreement' },
  { title: '隐私政策', value: '', action: 'privacyPolicy' },
  { title: '版本', value: '1.0.0', action: '' },
  { title: '注销账号', value: '', action: 'deleteAccount', destructive: true }
];
