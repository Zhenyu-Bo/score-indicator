import { McBarChart, Options } from '@mcui/mccharts'
import { it } from '@ohos/hypium';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import formProvider from '@ohos.app.form.formProvider';
import hilog from '@ohos.hilog';
import formBindingData from '@ohos.app.form.formBindingData';

interface Data {
  name: string;
  score: number;
}

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir + '/data6.json';

let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
fileIo.close(file);
// 2 通过fileIo.readSync读取json文件内容。
let data = fileIo.readTextSync(filePath)
if(data == ""){
  data = '[{"name":"第一组","score":0},{"name":"第二组","score":0},{"name":"第三组","score":0},{"name":"第四组","score":0},{"name":"第五组","score":0}]'
}

let temp: Data[] = JSON.parse(data);
onUpdate(temp);

function onUpdate(dump_data : Data[]) {
  // 创建文件，并且写入内容
  let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  fileIo.writeSync(file.fd, JSON.stringify(dump_data))
  fileIo.close(file);

  let obj: Data = dump_data[0];
  let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
  let filePath1= context.filesDir + "/formId1.json";
  let file1 = fileIo.openSync(filePath1, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  let formId = fileIo.readTextSync(filePath1);
  if (formId != '') {
    console.log('!!!!!!!!!!!!!!!!!!!!!!!!!', formId)
    formProvider.updateForm(formId, formData)
  }
}

// 一个辅助函数，限制小数位数并转换回 number 类型
function formatNumber(value: number, decimals: number): number {
  return parseFloat(value.toFixed(decimals));
}

@Entry
@Component
struct Index {

  compare(a: Data, b: Data) {
    return b.score - a.score;
  }
  @State data_teams: Data[] = temp;
  @State datas: Data[] = temp;

  getOption(sorted: Data[]): Options {

    //const sorted = [...this.data_teams].sort((a, b) => b.score - a.score);

    return new Options({

      xAxis:{
        axisLine: { // 轴线样式
          show: true, // 是否显示
          lineStyle: {
            color: '#ccc',
            width: 2
          }
        },
        axisTick: { // 刻度线配置
          show: true, // 是否显示
          length: 4, // 刻度的长度
          lineStyle: {
            color: '#ccc', // 刻度线颜色
            width: 2 // 刻度线宽度
          }
        },
        axisLabel: {  // x轴文本标签样式
          color: '#bf19ff',
          fontWeight: '600',
          fontFamily: 'sans-serif',
          fontSize: 40,
        },
        data: sorted.map(item => item.name),
      },
      yAxis: {
        name: '分数',
        axisLabel: {
          fontSize: 40
        }
      },
      series: [
        {
          name: 'Scores',
          data: sorted.map(item => item.score),
          BarStyle: {
            width: 100,
            Color: '#ff067fff'
          }
        }
      ]
    });
  }
  @State defOption: Options = new Options({
    xAxis:{
      axisLine: { // 轴线样式
        show: true, // 是否显示
        lineStyle: {
          color: '#ccc',
          width: 2
        }
      },
      axisTick: { // 刻度线配置
        show: true, // 是否显示
        length: 4, // 刻度的长度
        lineStyle: {
          color: '#ccc', // 刻度线颜色
          width: 2 // 刻度线宽度
        }
      },
      axisLabel: {  // x轴文本标签样式
        color: '#bf19ff',
        fontWeight: '600',
        fontFamily: 'sans-serif',
        fontSize: 40,
      },
      data: this.data_teams.map(item => item.name)
    },
    yAxis: {
      name:'得分'
    },
    series: [
      {
        name:'分数',
        data: [0, 0, 0, 0, 0],
        barStyle: {
          width: 100,
          Color: '#ff067fff'
        }
      }
    ],
  })

  aboutToAppear() {
    this.datas.sort(this.compare);
    this.defOption.setVal(this.getOption(this.datas))
  }
  @State simpleList: Array<number> = [0, 1, 2, 3, 4];

  build() {
    Column() {
      Row() {
        McBarChart({
          options: this.defOption
        })
      }
      .height('40%')

      Column({space: 35}) {
        Row() {
          ForEach(this.simpleList, (item: number) => {
            Column({ space: 30 }) {
              Button(' +1 ')
                .onClick(() => {
                  if(this.datas[item].name == '第二组' || this.datas[item].name == '第三组')
                    this.datas[item].score = formatNumber((this.data_teams[item].score + 1.167),3);
                  else
                    this.datas[item].score++;
                  this.datas.sort(this.compare);
                  onUpdate(this.datas);
                  //this.data_teams[item-1].score++;
                  this.defOption.setVal(this.getOption(this.datas));
                })
              Button(' +5 ')
                .onClick(() => {
                  if(this.datas[item].name == '第二组' || this.datas[item].name == '第三组')
                    this.datas[item].score = formatNumber((this.data_teams[item].score + 5.833),3);
                  else
                    this.datas[item].score += 5;
                  this.datas.sort(this.compare);
                  onUpdate(this.datas);
                  //this.data_teams[item-1].score++;
                  this.defOption.setVal(this.getOption(this.datas));
                })
              Button('+10')
                .onClick(() => {
                  if(this.datas[item].name == '第二组' || this.datas[item].name == '第三组')
                    this.datas[item].score = formatNumber((this.data_teams[item].score + 11.667),3);
                  else
                    this.datas[item].score += 10;
                  this.datas.sort(this.compare);
                  onUpdate(this.datas);
                  //this.data_teams[item-1].score++;
                  this.defOption.setVal(this.getOption(this.datas));
                })
              Button(' -1 ')
                .onClick(() => {
                  if((this.datas[item].name == '第二组' || this.datas[item].name == '第三组') && this.datas[item].score > 0)
                    this.datas[item].score = formatNumber((this.data_teams[item].score - 1.167),3);
                  else if(this.datas[item].score > 0)
                    this.datas[item].score -= 1;
                  this.datas.sort(this.compare);
                  onUpdate(this.datas);
                  //this.data_teams[item-1].score--;
                  this.defOption.setVal(this.getOption(this.datas));
                })
              Button(' -5 ')
                .onClick(() => {
                  if(this.datas[item].name == '第二组' || this.datas[item].name == '第三组' && this.datas[item].score > 0)
                    this.datas[item].score = formatNumber((this.data_teams[item].score - 5.833),3);
                  else if(this.datas[item].score > 0)
                    this.datas[item].score -= 5;
                  this.datas.sort(this.compare);
                  onUpdate(this.datas);
                  //this.data_teams[item-1].score--;
                  this.defOption.setVal(this.getOption(this.datas));
                })
              Button('-10')
                .onClick(() => {
                  if(this.datas[item].name == '第二组' || this.datas[item].name == '第三组' && this.datas[item].score > 0)
                    this.datas[item].score = formatNumber((this.data_teams[item].score - 11.667),3);
                  else if(this.datas[item].score > 0)
                    this.datas[item].score -= 10;
                  this.datas.sort(this.compare);
                  onUpdate(this.datas);
                  //this.data_teams[item-1].score--;
                  this.defOption.setVal(this.getOption(this.datas));
                })
              // TextInput({ placeholder: ''})
              //   .width('15%')
              //   .height(45)
              //   .type(InputType.Number)
              //   .enterKeyType(EnterKeyType.Done)
              //   .caretColor(Color.Red)
              //   .placeholderColor(Color.Green)
              //   .placeholderFont({
              //     size: 20,
              //     style: FontStyle.Italic,
              //     weight: FontWeight.Bold
              //   })
              //   .onChange((value) => {
              //     let value_temp: number = Number(value);
              //     if(value_temp >= 0) {
              //       this.datas[item-1].score = value_temp;
              //       this.datas.sort(this.compare);
              //       onUpdate(this.datas)
              //       //this.data_teams[item-1].score = value_temp;
              //       this.defOption.setVal(this.getOption(this.datas));
              //     }
              //   })
              // Text('第'+item+'组')
              //   .fontSize(15)
            }
          }, (item: number) => item.toString())
        }

        Row() {
          Button('      clear      ')
            .fontSize(20)
              //.fontColor(Color.Red)
            .padding({left: 80, right: 80})
            .onClick(() => {
              this.data_teams = [{name:"第一组", score:0}, {name:"第二组", score:0},{name:"第三组",score:0},{name:"第四组",score:0},{name:"第五组",score:0}];
              this.datas = this.data_teams;
              this.datas.sort(this.compare);
              onUpdate(this.datas);
              this.defOption.setVal(this.getOption(this.datas));
            })
        }
      }

    }
    .justifyContent(FlexAlign.SpaceAround)
  }
}