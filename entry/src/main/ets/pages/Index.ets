interface MemoItem {
  id: number;
  title: string;
  content: string;
  important: boolean;
  done: boolean;
  createdAt: string;
}

const PRIMARY_COLOR: string = '#0F766E';
const PRIMARY_LIGHT: string = '#DDF8F3';
const TEXT_COLOR: string = '#263238';
const SUB_TEXT_COLOR: string = '#7B8794';
const CARD_COLOR: string = '#FFFDF7';
const PAGE_BACKGROUND: string = '#F7F1E5';
const DANGER_COLOR: string = '#C2410C';
const SUCCESS_COLOR: string = '#3F8F4F';
const PAPER_LINE: string = '#F1E3C4';
const IMPORTANT_COLOR: string = '#B45309';
const RAIL_COLOR: string = '#123C3A';

@Builder
function SectionTitle(title: string, subTitle: string) {
  Row() {
    Column() {
      Text(title)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_COLOR)
      Text(subTitle)
        .fontSize(13)
        .fontColor(SUB_TEXT_COLOR)
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)

    Blank()
  }
  .width('100%')
  .padding({ top: 8, bottom: 8 })
}

@Builder
function EmptyState() {
  Column() {
    Text('空空如也')
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor(TEXT_COLOR)
    Text('点击底部按钮，写下第一条备忘录')
      .fontSize(14)
      .fontColor(SUB_TEXT_COLOR)
      .margin({ top: 8 })
  }
  .width('100%')
  .height(180)
  .justifyContent(FlexAlign.Center)
  .backgroundColor(CARD_COLOR)
  .border({ width: 1, color: PAPER_LINE })
  .borderRadius(28)
}

@Component
struct CountBadge {
  label: string = '';
  value: number = 0;
  color: string = PRIMARY_COLOR;

  build() {
    Column() {
      Text(this.value.toString())
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.color)
      Text(this.label)
        .fontSize(12)
        .fontColor(SUB_TEXT_COLOR)
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .height(78)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFC')
    .border({ width: 1, color: PAPER_LINE })
    .borderRadius(22)
  }
}

@Component
struct MemoCard {
  @Prop memo: MemoItem = {
    id: 0,
    title: '',
    content: '',
    important: false,
    done: false,
    createdAt: ''
  };
  onToggleDone: (id: number, done: boolean) => void = (id: number, done: boolean) => {};
  onEdit: (id: number) => void = (id: number) => {};
  onDelete: (id: number) => void = (id: number) => {};

  @Builder
  TagView() {
    Row() {
      Text(this.memo.important ? '重要' : '普通')
        .fontSize(12)
        .fontColor(this.memo.important ? IMPORTANT_COLOR : PRIMARY_COLOR)
        .padding({ left: 10, right: 10, top: 4, bottom: 4 })
        .backgroundColor(this.memo.important ? '#FFF4D6' : PRIMARY_LIGHT)
        .borderRadius(14)

      Text(this.memo.done ? '已完成' : '待处理')
        .fontSize(12)
        .fontColor(this.memo.done ? SUCCESS_COLOR : '#475569')
        .padding({ left: 10, right: 10, top: 4, bottom: 4 })
        .backgroundColor(this.memo.done ? '#E8F5E9' : '#ECEFF1')
        .borderRadius(14)
        .margin({ left: 8 })
    }
  }

  build() {
    Column() {
      Row() {
        Toggle({ type: ToggleType.Checkbox, isOn: this.memo.done })
          .selectedColor(SUCCESS_COLOR)
          .onChange((isOn: boolean) => {
            this.onToggleDone(this.memo.id, isOn);
          })

        Blank()

        Text(this.memo.createdAt)
          .fontSize(12)
          .fontColor('#9A8F7A')
      }
      .width('100%')

      Text(this.memo.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.memo.done ? '#9A8F7A' : TEXT_COLOR)
        .decoration({ type: this.memo.done ? TextDecorationType.LineThrough : TextDecorationType.None })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 16 })

      Text(this.memo.content)
        .fontSize(14)
        .fontColor(SUB_TEXT_COLOR)
        .lineHeight(22)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 10 })

      Blank()

      Row() {
        this.TagView()
        Blank()
        Button('编辑')
          .fontSize(12)
          .fontColor(PRIMARY_COLOR)
          .backgroundColor('#E7F5F2')
          .height(32)
          .borderRadius(16)
          .onClick(() => {
            this.onEdit(this.memo.id);
          })
        Button('删除')
          .fontSize(12)
          .fontColor(DANGER_COLOR)
          .backgroundColor('#FCE8DD')
          .height(32)
          .borderRadius(16)
          .margin({ left: 8 })
          .onClick(() => {
            this.onDelete(this.memo.id);
          })
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
    .height(184)
    .padding(18)
    .backgroundColor(this.memo.important ? '#FFF7D9' : CARD_COLOR)
    .border({ width: 1, color: this.memo.important ? '#F2D48B' : PAPER_LINE })
    .borderRadius(24)
    .shadow({
      radius: 10,
      color: '#12000000',
      offsetX: 0,
      offsetY: 5
    })
  }
}

@CustomDialog
struct MemoDialog {
  controller?: CustomDialogController;
  @Link title: string;
  @Link content: string;
  @Link important: boolean;
  @Link dialogTitle: string;
  @Link confirmText: string;
  onConfirm: () => void = () => {};

  build() {
    Column() {
      Text(this.dialogTitle)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_COLOR)
        .width('100%')
        .textAlign(TextAlign.Start)

      Text('把今天要记住的事情写下来')
        .fontSize(13)
        .fontColor(SUB_TEXT_COLOR)
        .width('100%')
        .margin({ top: 6 })

      TextInput({ placeholder: '备忘标题', text: this.title })
        .height(50)
        .fontSize(16)
        .backgroundColor('#FFFBF0')
        .border({ width: 1, color: PAPER_LINE })
        .borderRadius(18)
        .margin({ top: 22 })
        .onChange((value: string) => {
          this.title = value;
        })

      TextArea({ placeholder: '具体内容', text: this.content })
        .height(126)
        .fontSize(15)
        .backgroundColor('#FFFBF0')
        .border({ width: 1, color: PAPER_LINE })
        .borderRadius(18)
        .margin({ top: 12 })
        .onChange((value: string) => {
          this.content = value;
        })

      Row() {
        Column() {
          Text('重要提醒')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(TEXT_COLOR)
          Text('开启后卡片会带有醒目标记')
            .fontSize(12)
            .fontColor(SUB_TEXT_COLOR)
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.important })
          .selectedColor(IMPORTANT_COLOR)
          .onChange((isOn: boolean) => {
            this.important = isOn;
          })
      }
      .width('100%')
      .padding(14)
      .backgroundColor('#FAF2DF')
      .borderRadius(18)
      .margin({ top: 16 })

      Row() {
        Button('取消')
          .layoutWeight(1)
          .height(44)
          .fontColor(SUB_TEXT_COLOR)
          .backgroundColor('#EFE7D6')
          .borderRadius(18)
          .onClick(() => {
            this.controller?.close();
          })

        Button(this.confirmText)
          .layoutWeight(1)
          .height(44)
          .fontColor(Color.White)
          .backgroundColor(PRIMARY_COLOR)
          .borderRadius(18)
          .margin({ left: 12 })
          .onClick(() => {
            this.onConfirm();
            this.controller?.close();
          })
      }
      .width('100%')
      .margin({ top: 22 })
    }
    .padding(24)
    .backgroundColor('#FFFFFC')
    .borderRadius(30)
  }
}

@Entry
@Component
struct Index {
  @State memos: MemoItem[] = [
    {
      id: 1,
      title: '完成 HarmonyOS 课程作业',
      content: '使用 UIAbility、CustomDialog、Toggle 和自定义组件完成备忘录应用。',
      important: true,
      done: false,
      createdAt: '今天 09:00'
    },
    {
      id: 2,
      title: '整理课堂笔记',
      content: '复习 ArkTS 状态管理、组件化开发和自定义弹窗的使用方式。',
      important: false,
      done: true,
      createdAt: '昨天 20:30'
    }
  ];
  @State showDone: boolean = true;
  @State draftTitle: string = '';
  @State draftContent: string = '';
  @State draftImportant: boolean = false;
  @State editingId: number = 0;
  @State dialogTitle: string = '新建备忘录';
  @State confirmText: string = '添加';

  private dialogController: CustomDialogController = new CustomDialogController({
    builder: MemoDialog({
      title: $draftTitle,
      content: $draftContent,
      important: $draftImportant,
      dialogTitle: $dialogTitle,
      confirmText: $confirmText,
      onConfirm: () => {
        this.saveMemo();
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true
  });

  private totalCount(): number {
    return this.memos.length;
  }

  private doneCount(): number {
    return this.memos.filter((item: MemoItem) => item.done).length;
  }

  private todoCount(): number {
    return this.totalCount() - this.doneCount();
  }

  private visibleMemos(): MemoItem[] {
    if (this.showDone) {
      return this.memos;
    }
    return this.memos.filter((item: MemoItem) => !item.done);
  }

  private formatDate(): string {
    const now: Date = new Date();
    const hourValue: number = now.getHours();
    const minuteValue: number = now.getMinutes();
    const hour: string = hourValue < 10 ? `0${hourValue}` : hourValue.toString();
    const minute: string = minuteValue < 10 ? `0${minuteValue}` : minuteValue.toString();
    return `今天 ${hour}:${minute}`;
  }

  private openAddDialog(): void {
    this.editingId = 0;
    this.dialogTitle = '新建备忘录';
    this.confirmText = '添加';
    this.draftTitle = '';
    this.draftContent = '';
    this.draftImportant = false;
    this.dialogController.open();
  }

  private openEditDialog(id: number): void {
    const target: MemoItem | undefined = this.memos.find((item: MemoItem) => item.id === id);
    if (!target) {
      return;
    }
    this.editingId = id;
    this.dialogTitle = '编辑备忘录';
    this.confirmText = '保存';
    this.draftTitle = target.title;
    this.draftContent = target.content;
    this.draftImportant = target.important;
    this.dialogController.open();
  }

  private saveMemo(): void {
    const title: string = this.draftTitle.trim();
    const content: string = this.draftContent.trim();
    if (title.length === 0 && content.length === 0) {
      return;
    }

    if (this.editingId === 0) {
      const newMemo: MemoItem = {
        id: Date.now(),
        title: title.length > 0 ? title : '未命名备忘录',
        content: content.length > 0 ? content : '暂无详细内容',
        important: this.draftImportant,
        done: false,
        createdAt: this.formatDate()
      };
      this.memos = [newMemo, ...this.memos];
      return;
    }

    this.memos = this.memos.map((item: MemoItem) => {
      if (item.id !== this.editingId) {
        return item;
      }
      return {
        id: item.id,
        title: title.length > 0 ? title : '未命名备忘录',
        content: content.length > 0 ? content : '暂无详细内容',
        important: this.draftImportant,
        done: item.done,
        createdAt: item.createdAt
      };
    });
  }

  private toggleDone(id: number, done: boolean): void {
    this.memos = this.memos.map((item: MemoItem) => {
      if (item.id !== id) {
        return item;
      }
      return {
        id: item.id,
        title: item.title,
        content: item.content,
        important: item.important,
        done: done,
        createdAt: item.createdAt
      };
    });
  }

  private deleteMemo(id: number): void {
    this.memos = this.memos.filter((item: MemoItem) => item.id !== id);
  }

  @Builder
  SideRail() {
    Column() {
      Text('MEMO')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#DDF8F3')
        .rotate({ angle: -90 })
        .margin({ top: 28, bottom: 30 })

      Button('+')
        .width(46)
        .height(46)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(RAIL_COLOR)
        .backgroundColor('#F7F1E5')
        .borderRadius(23)
        .onClick(() => {
          this.openAddDialog();
        })

      Column({ space: 12 }) {
        Text(this.totalCount().toString())
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text('全部')
          .fontSize(12)
          .fontColor('#BFE8E3')
      }
      .margin({ top: 38 })

      Column({ space: 12 }) {
        Text(this.todoCount().toString())
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFD166')
        Text('待办')
          .fontSize(12)
          .fontColor('#BFE8E3')
      }
      .margin({ top: 34 })

      Blank()

      Text('备忘')
        .fontSize(14)
        .fontColor('#BFE8E3')
        .margin({ bottom: 24 })
    }
    .width(76)
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(RAIL_COLOR)
  }

  @Builder
  ContentHeader() {
    Column() {
      Row() {
        Column() {
          Text('事项工作台')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(TEXT_COLOR)
          Text('左侧快捷入口，右侧便签管理')
            .fontSize(13)
            .fontColor(SUB_TEXT_COLOR)
            .margin({ top: 6 })
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Toggle({ type: ToggleType.Switch, isOn: this.showDone })
          .selectedColor(PRIMARY_COLOR)
          .onChange((isOn: boolean) => {
            this.showDone = isOn;
          })
      }
      .width('100%')

      Row({ space: 10 }) {
        CountBadge({ label: '全部', value: this.totalCount(), color: PRIMARY_COLOR })
        CountBadge({ label: '待办', value: this.todoCount(), color: IMPORTANT_COLOR })
        CountBadge({ label: '完成', value: this.doneCount(), color: SUCCESS_COLOR })
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 28, bottom: 18 })
    .backgroundColor('#FFF8E8')
    .borderRadius(28)
    .border({ width: 1, color: '#EFE0BC' })
  }

  build() {
    Row() {
      this.SideRail()

      Column() {
        this.ContentHeader()

        SectionTitle('便签列表', this.showDone ? '当前显示全部状态' : '当前只显示待办')

        Scroll() {
          Column({ space: 16 }) {
            if (this.visibleMemos().length === 0) {
              EmptyState()
            } else {
              ForEach(this.visibleMemos(), (memo: MemoItem) => {
                MemoCard({
                  memo: memo,
                  onToggleDone: (id: number, done: boolean) => {
                    this.toggleDone(id, done);
                  },
                  onEdit: (id: number) => {
                    this.openEditDialog(id);
                  },
                  onDelete: (id: number) => {
                    this.deleteMemo(id);
                  }
                })
              }, (memo: MemoItem) => memo.id.toString())
            }
          }
          .width('100%')
          .padding({ bottom: 96 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .layoutWeight(1)
      .height('100%')
      .padding({ left: 16, right: 16, top: 18, bottom: 0 })
      .backgroundColor(PAGE_BACKGROUND)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(PAGE_BACKGROUND)
  }
}
