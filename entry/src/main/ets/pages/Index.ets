interface MemoItem {
  id: number;
  title: string;
  content: string;
  important: boolean;
  done: boolean;
  createdAt: string;
}

const PRIMARY_COLOR: string = '#4F7FFF';
const PRIMARY_LIGHT: string = '#EEF3FF';
const TEXT_COLOR: string = '#1F2937';
const SUB_TEXT_COLOR: string = '#6B7280';
const CARD_COLOR: string = '#FFFFFF';
const PAGE_BACKGROUND: string = '#F6F8FF';
const DANGER_COLOR: string = '#F05252';
const SUCCESS_COLOR: string = '#22C55E';

@Builder
function SectionHeader(title: string, subTitle: string) {
  Row() {
    Column() {
      Text(title)
        .fontSize(20)
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
  .padding({ left: 2, right: 2, top: 8, bottom: 8 })
}

@Builder
function EmptyState() {
  Column() {
    Text('📝')
      .fontSize(42)
    Text('暂无备忘录')
      .fontSize(18)
      .fontWeight(FontWeight.Medium)
      .fontColor(TEXT_COLOR)
      .margin({ top: 12 })
    Text('点击右下角按钮创建第一条备忘录')
      .fontSize(14)
      .fontColor(SUB_TEXT_COLOR)
      .margin({ top: 6 })
  }
  .width('100%')
  .padding(32)
  .backgroundColor(CARD_COLOR)
  .borderRadius(24)
}

@Component
struct StatCard {
  label: string = '';
  value: number = 0;
  color: string = PRIMARY_COLOR;

  build() {
    Column() {
      Text(this.value.toString())
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.color)
      Text(this.label)
        .fontSize(12)
        .fontColor(SUB_TEXT_COLOR)
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .padding({ top: 14, bottom: 14 })
    .backgroundColor(CARD_COLOR)
    .borderRadius(18)
    .shadow({
      radius: 14,
      color: '#14000000',
      offsetX: 0,
      offsetY: 4
    })
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
  StatusPill() {
    Text(this.memo.done ? '已完成' : '待办')
      .fontSize(12)
      .fontColor(this.memo.done ? SUCCESS_COLOR : PRIMARY_COLOR)
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })
      .backgroundColor(this.memo.done ? '#EAFBF1' : PRIMARY_LIGHT)
      .borderRadius(12)
  }

  build() {
    Column() {
      Row() {
        Toggle({ type: ToggleType.Checkbox, isOn: this.memo.done })
          .selectedColor(SUCCESS_COLOR)
          .onChange((isOn: boolean) => {
            this.onToggleDone(this.memo.id, isOn);
          })

        Column() {
          Row() {
            Text(this.memo.title)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.memo.done ? SUB_TEXT_COLOR : TEXT_COLOR)
              .decoration({ type: this.memo.done ? TextDecorationType.LineThrough : TextDecorationType.None })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            if (this.memo.important) {
              Text('重要')
                .fontSize(11)
                .fontColor('#C2410C')
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .backgroundColor('#FFF2E8')
                .borderRadius(10)
                .margin({ left: 8 })
            }
          }
          .width('100%')

          Text(this.memo.content)
            .fontSize(14)
            .fontColor(SUB_TEXT_COLOR)
            .lineHeight(20)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      Row() {
        Text(this.memo.createdAt)
          .fontSize(12)
          .fontColor('#9CA3AF')

        Blank()

        this.StatusPill()

        Button('编辑')
          .fontSize(12)
          .fontColor(PRIMARY_COLOR)
          .backgroundColor(PRIMARY_LIGHT)
          .borderRadius(14)
          .height(30)
          .margin({ left: 8 })
          .onClick(() => {
            this.onEdit(this.memo.id);
          })

        Button('删除')
          .fontSize(12)
          .fontColor(DANGER_COLOR)
          .backgroundColor('#FFF1F1')
          .borderRadius(14)
          .height(30)
          .margin({ left: 8 })
          .onClick(() => {
            this.onDelete(this.memo.id);
          })
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(CARD_COLOR)
    .borderRadius(22)
    .shadow({
      radius: 16,
      color: '#16000000',
      offsetX: 0,
      offsetY: 6
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
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(TEXT_COLOR)
        .width('100%')
        .textAlign(TextAlign.Start)

      TextInput({ placeholder: '请输入标题', text: $$this.title })
        .height(48)
        .fontSize(16)
        .backgroundColor('#F3F6FF')
        .borderRadius(14)
        .margin({ top: 20 })

      TextArea({ placeholder: '请输入备忘内容', text: $$this.content })
        .height(120)
        .fontSize(15)
        .backgroundColor('#F3F6FF')
        .borderRadius(14)
        .margin({ top: 12 })

      Row() {
        Text('标记为重要')
          .fontSize(15)
          .fontColor(TEXT_COLOR)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.important })
          .selectedColor('#FF9F43')
          .onChange((isOn: boolean) => {
            this.important = isOn;
          })
      }
      .width('100%')
      .margin({ top: 16 })

      Row() {
        Button('取消')
          .layoutWeight(1)
          .height(42)
          .fontColor(SUB_TEXT_COLOR)
          .backgroundColor('#F3F4F6')
          .borderRadius(16)
          .onClick(() => {
            this.controller?.close();
          })

        Button(this.confirmText)
          .layoutWeight(1)
          .height(42)
          .fontColor(Color.White)
          .backgroundColor(PRIMARY_COLOR)
          .borderRadius(16)
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
    .backgroundColor(Color.White)
    .borderRadius(26)
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
  HeaderArea() {
    Column() {
      Text('简洁备忘录')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
      Text('记录灵感，安排每天的重要事项')
        .fontSize(14)
        .fontColor('#EAF0FF')
        .margin({ top: 8 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 24, right: 24, top: 44, bottom: 34 })
    .backgroundColor(PRIMARY_COLOR)
    .borderRadius({ bottomLeft: 30, bottomRight: 30 })
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        this.HeaderArea()

        Column() {
          Row({ space: 10 }) {
            StatCard({ label: '全部', value: this.totalCount(), color: PRIMARY_COLOR })
            StatCard({ label: '待办', value: this.todoCount(), color: '#F59E0B' })
            StatCard({ label: '完成', value: this.doneCount(), color: SUCCESS_COLOR })
          }
          .width('100%')
          .margin({ top: -22 })

          Row() {
            SectionHeader('备忘列表', this.showDone ? '显示全部事项' : '仅显示待办事项')
            Row() {
              Text('显示已完成')
                .fontSize(13)
                .fontColor(SUB_TEXT_COLOR)
              Toggle({ type: ToggleType.Switch, isOn: this.showDone })
                .selectedColor(PRIMARY_COLOR)
                .margin({ left: 8 })
                .onChange((isOn: boolean) => {
                  this.showDone = isOn;
                })
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 16 })

          Scroll() {
            Column({ space: 14 }) {
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
        .padding({ left: 18, right: 18 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(PAGE_BACKGROUND)

      Button('+')
        .width(58)
        .height(58)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor(PRIMARY_COLOR)
        .borderRadius(29)
        .shadow({
          radius: 18,
          color: '#334F7FFF',
          offsetX: 0,
          offsetY: 8
        })
        .margin({ right: 22, bottom: 28 })
        .onClick(() => {
          this.openAddDialog();
        })
    }
    .width('100%')
    .height('100%')
  }
}
