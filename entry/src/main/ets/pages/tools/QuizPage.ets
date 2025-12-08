import router from '@ohos.router';
import { preferences } from '@kit.ArkData';
import common from '@ohos.app.ability.common';

interface QuizQuestion {
    question: string;
    options: string[];
    correctAnswer: number;
    explanation: string;
}

@Entry
@Component
struct QuizPage {
    @State currentQuestionIndex: number = 0;
    @State selectedAnswer: number = -1;
    @State showResult: boolean = false;
    @State score: number = 0;
    @State answeredQuestions: number[] = [];
    @State showCompletedDialog: boolean = false;

    private prefs: preferences.Preferences | null = null;
    private context = getContext(this) as common.UIAbilityContext;

    private questions: QuizQuestion[] = [
        {
            question: '下列哪项属于资产类科目？',
            options: ['应付账款', '应收账款', '预收账款', '应付职工薪酬'],
            correctAnswer: 1,
            explanation: '应收账款属于资产类科目，表示企业因销售商品、提供服务等经营活动应收取的款项。'
        },
        {
            question: '增值税一般纳税人的基本税率是？',
            options: ['3%', '6%', '9%', '13%'],
            correctAnswer: 3,
            explanation: '增值税一般纳税人的基本税率是13%，适用于销售货物、提供加工修理修配劳务等。'
        },
        {
            question: '下列哪项不属于会计基本假设？',
            options: ['会计主体', '持续经营', '会计分期', '历史成本'],
            correctAnswer: 3,
            explanation: '会计基本假设包括会计主体、持续经营、会计分期和货币计量。历史成本是计量属性，不是基本假设。'
        },
        {
            question: '企业计提固定资产折旧时，应借记的科目是？',
            options: ['固定资产', '累计折旧', '管理费用', '制造费用'],
            correctAnswer: 2,
            explanation: '计提固定资产折旧时，借记"管理费用"（管理部门）或"制造费用"（生产部门），贷记"累计折旧"。'
        },
        {
            question: '小规模纳税人月销售额不超过多少万元免征增值税？',
            options: ['10万元', '15万元', '20万元', '30万元'],
            correctAnswer: 1,
            explanation: '根据最新政策，小规模纳税人月销售额不超过15万元（季度销售额不超过45万元）的，免征增值税。'
        },
        {
            question: '资产负债表反映的是？',
            options: ['某一时点的财务状况', '某一时期的经营成果', '某一时期的现金流量', '某一时点的经营成果'],
            correctAnswer: 0,
            explanation: '资产负债表是反映企业在某一特定日期（时点）财务状况的报表，包括资产、负债和所有者权益。'
        },
        {
            question: '利润表反映的是？',
            options: ['某一时点的财务状况', '某一时期的经营成果', '某一时期的现金流量', '某一时点的经营成果'],
            correctAnswer: 1,
            explanation: '利润表是反映企业在一定会计期间（时期）经营成果的报表，包括收入、费用和利润。'
        },
        {
            question: '会计等式的基本形式是？',
            options: ['资产=负债', '资产=负债+所有者权益', '收入=费用', '资产=收入'],
            correctAnswer: 1,
            explanation: '会计等式的基本形式是：资产=负债+所有者权益，这是复式记账的基础。'
        },
        {
            question: '下列哪项属于负债类科目？',
            options: ['应收账款', '预付账款', '应付账款', '其他应收款'],
            correctAnswer: 2,
            explanation: '应付账款属于负债类科目，表示企业因购买商品、接受服务等经营活动应支付的款项。'
        },
        {
            question: '企业销售商品收到现金，应借记？',
            options: ['应收账款', '库存现金', '主营业务收入', '银行存款'],
            correctAnswer: 1,
            explanation: '销售商品收到现金，应借记"库存现金"或"银行存款"，贷记"主营业务收入"。'
        },
        {
            question: '企业购买原材料，应借记？',
            options: ['原材料', '库存商品', '主营业务成本', '管理费用'],
            correctAnswer: 0,
            explanation: '购买原材料时，应借记"原材料"科目，贷记"银行存款"或"应付账款"等。'
        },
        {
            question: '企业计提坏账准备，应借记？',
            options: ['应收账款', '坏账准备', '资产减值损失', '管理费用'],
            correctAnswer: 2,
            explanation: '计提坏账准备时，应借记"资产减值损失"，贷记"坏账准备"。'
        },
        {
            question: '企业支付职工工资，应借记？',
            options: ['应付职工薪酬', '管理费用', '销售费用', '制造费用'],
            correctAnswer: 0,
            explanation: '支付职工工资时，应借记"应付职工薪酬"，贷记"银行存款"或"库存现金"。'
        },
        {
            question: '企业收到投资者投入资本，应贷记？',
            options: ['银行存款', '实收资本', '资本公积', '盈余公积'],
            correctAnswer: 1,
            explanation: '收到投资者投入资本时，应借记"银行存款"等资产科目，贷记"实收资本"或"股本"。'
        },
        {
            question: '企业计提所得税费用，应借记？',
            options: ['应交税费', '所得税费用', '递延所得税资产', '递延所得税负债'],
            correctAnswer: 1,
            explanation: '计提所得税费用时，应借记"所得税费用"，贷记"应交税费-应交所得税"。'
        },
        {
            question: '企业结转主营业务成本，应借记？',
            options: ['主营业务收入', '主营业务成本', '库存商品', '生产成本'],
            correctAnswer: 1,
            explanation: '结转主营业务成本时，应借记"主营业务成本"，贷记"库存商品"。'
        },
        {
            question: '企业计提盈余公积，应借记？',
            options: ['利润分配', '盈余公积', '未分配利润', '资本公积'],
            correctAnswer: 0,
            explanation: '计提盈余公积时，应借记"利润分配-提取盈余公积"，贷记"盈余公积"。'
        },
        {
            question: '企业发生销售费用，应借记？',
            options: ['管理费用', '销售费用', '财务费用', '制造费用'],
            correctAnswer: 1,
            explanation: '发生销售费用时，应借记"销售费用"，贷记"银行存款"、"应付职工薪酬"等。'
        },
        {
            question: '企业发生财务费用，应借记？',
            options: ['管理费用', '销售费用', '财务费用', '制造费用'],
            correctAnswer: 2,
            explanation: '发生财务费用时，应借记"财务费用"，贷记"银行存款"、"应付利息"等。'
        },
        {
            question: '企业发生管理费用，应借记？',
            options: ['管理费用', '销售费用', '财务费用', '制造费用'],
            correctAnswer: 0,
            explanation: '发生管理费用时，应借记"管理费用"，贷记"银行存款"、"应付职工薪酬"等。'
        },
        {
            question: '企业计提固定资产减值准备，应借记？',
            options: ['固定资产', '累计折旧', '资产减值损失', '固定资产减值准备'],
            correctAnswer: 2,
            explanation: '计提固定资产减值准备时，应借记"资产减值损失"，贷记"固定资产减值准备"。'
        },
        {
            question: '企业计提无形资产摊销，应借记？',
            options: ['无形资产', '累计摊销', '管理费用', '制造费用'],
            correctAnswer: 2,
            explanation: '计提无形资产摊销时，应借记"管理费用"等科目，贷记"累计摊销"。'
        },
        {
            question: '企业发生研发支出，应借记？',
            options: ['研发支出', '管理费用', '无形资产', '生产成本'],
            correctAnswer: 0,
            explanation: '发生研发支出时，应借记"研发支出"，贷记"银行存款"、"应付职工薪酬"等。'
        },
        {
            question: '企业确认投资收益，应贷记？',
            options: ['投资收益', '长期股权投资', '银行存款', '应收股利'],
            correctAnswer: 0,
            explanation: '确认投资收益时，应借记"应收股利"或"银行存款"，贷记"投资收益"。'
        },
        {
            question: '企业发生营业外收入，应贷记？',
            options: ['营业外收入', '主营业务收入', '其他业务收入', '投资收益'],
            correctAnswer: 0,
            explanation: '发生营业外收入时，应借记"银行存款"等科目，贷记"营业外收入"。'
        },
        {
            question: '企业发生营业外支出，应借记？',
            options: ['营业外支出', '主营业务成本', '其他业务成本', '管理费用'],
            correctAnswer: 0,
            explanation: '发生营业外支出时，应借记"营业外支出"，贷记"银行存款"、"固定资产清理"等。'
        },
        {
            question: '企业确认其他业务收入，应贷记？',
            options: ['主营业务收入', '其他业务收入', '营业外收入', '投资收益'],
            correctAnswer: 1,
            explanation: '确认其他业务收入时，应借记"银行存款"等科目，贷记"其他业务收入"。'
        },
        {
            question: '企业确认其他业务成本，应借记？',
            options: ['主营业务成本', '其他业务成本', '营业外支出', '管理费用'],
            correctAnswer: 1,
            explanation: '确认其他业务成本时，应借记"其他业务成本"，贷记"原材料"、"累计折旧"等。'
        },
        {
            question: '企业计提存货跌价准备，应借记？',
            options: ['存货', '存货跌价准备', '资产减值损失', '主营业务成本'],
            correctAnswer: 2,
            explanation: '计提存货跌价准备时，应借记"资产减值损失"，贷记"存货跌价准备"。'
        },
        {
            question: '企业确认公允价值变动收益，应贷记？',
            options: ['投资收益', '公允价值变动损益', '营业外收入', '其他业务收入'],
            correctAnswer: 1,
            explanation: '确认公允价值变动收益时，应借记"交易性金融资产"等科目，贷记"公允价值变动损益"。'
        },
        {
            question: '企业计提长期股权投资减值准备，应借记？',
            options: ['长期股权投资', '长期股权投资减值准备', '资产减值损失', '投资收益'],
            correctAnswer: 2,
            explanation: '计提长期股权投资减值准备时，应借记"资产减值损失"，贷记"长期股权投资减值准备"。'
        },
        {
            question: '企业计提在建工程减值准备，应借记？',
            options: ['在建工程', '在建工程减值准备', '资产减值损失', '工程物资'],
            correctAnswer: 2,
            explanation: '计提在建工程减值准备时，应借记"资产减值损失"，贷记"在建工程减值准备"。'
        },
        {
            question: '企业计提商誉减值准备，应借记？',
            options: ['商誉', '商誉减值准备', '资产减值损失', '无形资产'],
            correctAnswer: 2,
            explanation: '计提商誉减值准备时，应借记"资产减值损失"，贷记"商誉减值准备"。'
        },
        {
            question: '企业计提持有至到期投资减值准备，应借记？',
            options: ['持有至到期投资', '持有至到期投资减值准备', '资产减值损失', '投资收益'],
            correctAnswer: 2,
            explanation: '计提持有至到期投资减值准备时，应借记"资产减值损失"，贷记"持有至到期投资减值准备"。'
        },
        {
            question: '企业计提可供出售金融资产减值准备，应借记？',
            options: ['可供出售金融资产', '可供出售金融资产减值准备', '资产减值损失', '其他综合收益'],
            correctAnswer: 2,
            explanation: '计提可供出售金融资产减值准备时，应借记"资产减值损失"，贷记"可供出售金融资产减值准备"。'
        },
        {
            question: '企业计提生产性生物资产减值准备，应借记？',
            options: ['生产性生物资产', '生产性生物资产减值准备', '资产减值损失', '消耗性生物资产'],
            correctAnswer: 2,
            explanation: '计提生产性生物资产减值准备时，应借记"资产减值损失"，贷记"生产性生物资产减值准备"。'
        },
        {
            question: '企业计提油气资产减值准备，应借记？',
            options: ['油气资产', '油气资产减值准备', '资产减值损失', '累计折耗'],
            correctAnswer: 2,
            explanation: '计提油气资产减值准备时，应借记"资产减值损失"，贷记"油气资产减值准备"。'
        },
        {
            question: '企业计提投资性房地产减值准备，应借记？',
            options: ['投资性房地产', '投资性房地产减值准备', '资产减值损失', '公允价值变动损益'],
            correctAnswer: 2,
            explanation: '计提投资性房地产减值准备时，应借记"资产减值损失"，贷记"投资性房地产减值准备"。'
        },
        {
            question: '企业计提消耗性生物资产减值准备，应借记？',
            options: ['消耗性生物资产', '消耗性生物资产减值准备', '资产减值损失', '生产性生物资产'],
            correctAnswer: 2,
            explanation: '计提消耗性生物资产减值准备时，应借记"资产减值损失"，贷记"消耗性生物资产减值准备"。'
        },
        {
            question: '企业计提建造合同形成的资产减值准备，应借记？',
            options: ['工程施工', '工程结算', '资产减值损失', '合同履约成本'],
            correctAnswer: 2,
            explanation: '计提建造合同形成的资产减值准备时，应借记"资产减值损失"，贷记相应的减值准备科目。'
        },
        {
            question: '企业计提递延所得税资产，应借记？',
            options: ['递延所得税资产', '递延所得税负债', '所得税费用', '应交税费'],
            correctAnswer: 0,
            explanation: '确认递延所得税资产时，应借记"递延所得税资产"，贷记"所得税费用"或"其他综合收益"。'
        },
        {
            question: '企业计提递延所得税负债，应借记？',
            options: ['递延所得税资产', '递延所得税负债', '所得税费用', '应交税费'],
            correctAnswer: 2,
            explanation: '确认递延所得税负债时，应借记"所得税费用"或"其他综合收益"，贷记"递延所得税负债"。'
        },
        {
            question: '企业确认预计负债，应借记？',
            options: ['预计负债', '营业外支出', '管理费用', '销售费用'],
            correctAnswer: 1,
            explanation: '确认预计负债时，应借记"营业外支出"、"管理费用"等科目，贷记"预计负债"。'
        },
        {
            question: '企业确认或有负债，应借记？',
            options: ['或有负债', '营业外支出', '管理费用', '销售费用'],
            correctAnswer: 1,
            explanation: '确认或有负债时，应借记"营业外支出"、"管理费用"等科目，贷记"预计负债"。'
        },
        {
            question: '企业确认或有资产，应贷记？',
            options: ['或有资产', '营业外收入', '其他业务收入', '投资收益'],
            correctAnswer: 1,
            explanation: '确认或有资产时，应借记"其他应收款"等科目，贷记"营业外收入"。'
        },
        {
            question: '企业确认资产处置收益，应贷记？',
            options: ['资产处置收益', '营业外收入', '其他业务收入', '投资收益'],
            correctAnswer: 0,
            explanation: '确认资产处置收益时，应借记"固定资产清理"等科目，贷记"资产处置收益"。'
        },
        {
            question: '企业确认资产处置损失，应借记？',
            options: ['资产处置收益', '资产处置损失', '营业外支出', '其他业务成本'],
            correctAnswer: 0,
            explanation: '确认资产处置损失时，应借记"资产处置收益"（负数），贷记"固定资产清理"等科目。'
        },
        {
            question: '企业确认信用减值损失，应借记？',
            options: ['信用减值损失', '资产减值损失', '坏账准备', '应收账款'],
            correctAnswer: 0,
            explanation: '确认信用减值损失时，应借记"信用减值损失"，贷记"坏账准备"等科目。'
        },
        {
            question: '企业确认其他收益，应贷记？',
            options: ['其他收益', '营业外收入', '其他业务收入', '投资收益'],
            correctAnswer: 0,
            explanation: '确认其他收益时，应借记"银行存款"等科目，贷记"其他收益"。'
        },
        {
            question: '企业确认资产处置收益（处置固定资产），应贷记？',
            options: ['资产处置收益', '营业外收入', '其他业务收入', '投资收益'],
            correctAnswer: 0,
            explanation: '处置固定资产产生收益时，应借记"固定资产清理"，贷记"资产处置收益"。'
        },
        {
            question: '企业确认资产处置损失（处置固定资产），应借记？',
            options: ['资产处置收益', '资产处置损失', '营业外支出', '其他业务成本'],
            correctAnswer: 0,
            explanation: '处置固定资产产生损失时，应借记"资产处置收益"（负数），贷记"固定资产清理"。'
        },
        {
            question: '企业确认其他综合收益，应贷记？',
            options: ['其他综合收益', '资本公积', '盈余公积', '未分配利润'],
            correctAnswer: 0,
            explanation: '确认其他综合收益时，应借记相关科目，贷记"其他综合收益"。'
        },
        {
            question: '企业确认综合收益总额，应贷记？',
            options: ['综合收益总额', '净利润', '其他综合收益', '未分配利润'],
            correctAnswer: 1,
            explanation: '综合收益总额=净利润+其他综合收益，不是单独的会计科目。'
        },
        {
            question: '企业确认归属于母公司所有者的净利润，应贷记？',
            options: ['归属于母公司所有者的净利润', '少数股东损益', '净利润', '未分配利润'],
            correctAnswer: 2,
            explanation: '归属于母公司所有者的净利润是利润表的项目，不是单独的会计科目。'
        },
        {
            question: '企业确认少数股东损益，应借记？',
            options: ['少数股东损益', '归属于母公司所有者的净利润', '净利润', '未分配利润'],
            correctAnswer: 0,
            explanation: '确认少数股东损益时，应借记"少数股东损益"，贷记"少数股东权益"。'
        },
        {
            question: '企业确认基本每股收益，应如何计算？',
            options: ['净利润/发行在外普通股加权平均数', '净利润/发行在外普通股总数', '利润总额/发行在外普通股加权平均数', '营业收入/发行在外普通股加权平均数'],
            correctAnswer: 0,
            explanation: '基本每股收益=归属于普通股股东的当期净利润÷发行在外普通股加权平均数。'
        },
        {
            question: '企业确认稀释每股收益，应如何计算？',
            options: ['净利润/发行在外普通股加权平均数', '调整后净利润/调整后发行在外普通股加权平均数', '利润总额/发行在外普通股加权平均数', '营业收入/发行在外普通股加权平均数'],
            correctAnswer: 1,
            explanation: '稀释每股收益=调整后归属于普通股股东的当期净利润÷调整后发行在外普通股加权平均数。'
        },
        {
            question: '企业确认每股净资产，应如何计算？',
            options: ['资产总额/发行在外普通股总数', '净资产/发行在外普通股总数', '净利润/发行在外普通股总数', '营业收入/发行在外普通股总数'],
            correctAnswer: 1,
            explanation: '每股净资产=股东权益总额÷发行在外普通股总数。'
        },
        {
            question: '企业确认每股经营活动产生的现金流量净额，应如何计算？',
            options: ['经营活动产生的现金流量净额/发行在外普通股加权平均数', '经营活动产生的现金流量净额/发行在外普通股总数', '现金及现金等价物净增加额/发行在外普通股加权平均数', '净利润/发行在外普通股加权平均数'],
            correctAnswer: 0,
            explanation: '每股经营活动产生的现金流量净额=经营活动产生的现金流量净额÷发行在外普通股加权平均数。'
        },
        {
            question: '企业确认净资产收益率（ROE），应如何计算？',
            options: ['净利润/资产总额', '净利润/平均股东权益', '利润总额/平均股东权益', '营业收入/平均股东权益'],
            correctAnswer: 1,
            explanation: '净资产收益率（ROE）=净利润÷平均股东权益，反映股东权益的收益水平。'
        },
        {
            question: '企业确认总资产收益率（ROA），应如何计算？',
            options: ['净利润/资产总额', '净利润/平均资产总额', '利润总额/平均资产总额', '营业收入/平均资产总额'],
            correctAnswer: 1,
            explanation: '总资产收益率（ROA）=净利润÷平均资产总额，反映企业全部资产的盈利能力。'
        },
        {
            question: '企业确认销售毛利率，应如何计算？',
            options: ['(营业收入-营业成本)/营业收入', '(营业收入-营业成本)/营业成本', '营业收入/营业成本', '营业成本/营业收入'],
            correctAnswer: 0,
            explanation: '销售毛利率=(营业收入-营业成本)÷营业收入，反映企业产品或服务的盈利能力。'
        },
        {
            question: '企业确认销售净利率，应如何计算？',
            options: ['净利润/营业收入', '利润总额/营业收入', '营业利润/营业收入', '营业收入/净利润'],
            correctAnswer: 0,
            explanation: '销售净利率=净利润÷营业收入，反映企业最终盈利能力。'
        },
        {
            question: '企业确认资产周转率，应如何计算？',
            options: ['营业收入/资产总额', '营业收入/平均资产总额', '净利润/平均资产总额', '营业成本/平均资产总额'],
            correctAnswer: 1,
            explanation: '资产周转率=营业收入÷平均资产总额，反映企业资产利用效率。'
        },
        {
            question: '企业确认存货周转率，应如何计算？',
            options: ['营业收入/存货', '营业成本/平均存货', '净利润/平均存货', '营业收入/平均存货'],
            correctAnswer: 1,
            explanation: '存货周转率=营业成本÷平均存货，反映存货周转速度。'
        },
        {
            question: '企业确认应收账款周转率，应如何计算？',
            options: ['营业收入/应收账款', '营业收入/平均应收账款', '净利润/平均应收账款', '营业成本/平均应收账款'],
            correctAnswer: 1,
            explanation: '应收账款周转率=营业收入÷平均应收账款，反映应收账款周转速度。'
        },
        {
            question: '企业确认流动比率，应如何计算？',
            options: ['流动资产/流动负债', '流动负债/流动资产', '流动资产/资产总额', '流动负债/负债总额'],
            correctAnswer: 0,
            explanation: '流动比率=流动资产÷流动负债，反映企业短期偿债能力。'
        },
        {
            question: '企业确认速动比率，应如何计算？',
            options: ['流动资产/流动负债', '(流动资产-存货)/流动负债', '流动负债/(流动资产-存货)', '流动资产/资产总额'],
            correctAnswer: 1,
            explanation: '速动比率=(流动资产-存货)÷流动负债，反映企业立即偿债能力。'
        },
        {
            question: '企业确认资产负债率，应如何计算？',
            options: ['资产总额/负债总额', '负债总额/资产总额', '负债总额/所有者权益', '所有者权益/负债总额'],
            correctAnswer: 1,
            explanation: '资产负债率=负债总额÷资产总额，反映企业资产中有多少是通过负债筹集的。'
        },
        {
            question: '企业确认权益乘数，应如何计算？',
            options: ['资产总额/所有者权益', '所有者权益/资产总额', '负债总额/所有者权益', '所有者权益/负债总额'],
            correctAnswer: 0,
            explanation: '权益乘数=资产总额÷所有者权益，反映企业财务杠杆水平。'
        },
        {
            question: '企业确认利息保障倍数，应如何计算？',
            options: ['(利润总额+利息费用)/利息费用', '(净利润+利息费用)/利息费用', '利润总额/利息费用', '净利润/利息费用'],
            correctAnswer: 0,
            explanation: '利息保障倍数=(利润总额+利息费用)÷利息费用，反映企业支付利息的能力。'
        },
        {
            question: '企业确认现金比率，应如何计算？',
            options: ['货币资金/流动负债', '流动资产/流动负债', '货币资金/资产总额', '流动负债/货币资金'],
            correctAnswer: 0,
            explanation: '现金比率=货币资金÷流动负债，反映企业立即偿债能力。'
        },
        {
            question: '企业确认现金流量比率，应如何计算？',
            options: ['经营活动产生的现金流量净额/流动负债', '现金及现金等价物净增加额/流动负债', '投资活动产生的现金流量净额/流动负债', '筹资活动产生的现金流量净额/流动负债'],
            correctAnswer: 0,
            explanation: '现金流量比率=经营活动产生的现金流量净额÷流动负债，反映企业用经营活动现金流量偿还流动负债的能力。'
        },
        {
            question: '企业确认现金流量利息保障倍数，应如何计算？',
            options: ['(经营活动产生的现金流量净额+现金利息支出)/现金利息支出', '经营活动产生的现金流量净额/现金利息支出', '现金及现金等价物净增加额/现金利息支出', '净利润/现金利息支出'],
            correctAnswer: 0,
            explanation: '现金流量利息保障倍数=(经营活动产生的现金流量净额+现金利息支出)÷现金利息支出，反映企业用经营活动现金流量支付利息的能力。'
        },
        {
            question: '企业确认现金流量债务比，应如何计算？',
            options: ['经营活动产生的现金流量净额/负债总额', '现金及现金等价物净增加额/负债总额', '投资活动产生的现金流量净额/负债总额', '筹资活动产生的现金流量净额/负债总额'],
            correctAnswer: 0,
            explanation: '现金流量债务比=经营活动产生的现金流量净额÷负债总额，反映企业用经营活动现金流量偿还全部债务的能力。'
        },
        {
            question: '企业确认每股收益（EPS），应如何计算？',
            options: ['净利润/发行在外普通股加权平均数', '净利润/发行在外普通股总数', '利润总额/发行在外普通股加权平均数', '营业收入/发行在外普通股加权平均数'],
            correctAnswer: 0,
            explanation: '每股收益（EPS）=归属于普通股股东的当期净利润÷发行在外普通股加权平均数。'
        },
        {
            question: '企业确认市盈率（P/E），应如何计算？',
            options: ['每股市价/每股收益', '每股收益/每股市价', '每股市价/每股净资产', '每股净资产/每股市价'],
            correctAnswer: 0,
            explanation: '市盈率（P/E）=每股市价÷每股收益，反映投资者对公司未来盈利的预期。'
        },
        {
            question: '企业确认市净率（P/B），应如何计算？',
            options: ['每股市价/每股净资产', '每股净资产/每股市价', '每股市价/每股收益', '每股收益/每股市价'],
            correctAnswer: 0,
            explanation: '市净率（P/B）=每股市价÷每股净资产，反映投资者对公司净资产的估值。'
        },
        {
            question: '企业确认市销率（P/S），应如何计算？',
            options: ['每股市价/每股营业收入', '每股营业收入/每股市价', '每股市价/每股收益', '每股收益/每股市价'],
            correctAnswer: 0,
            explanation: '市销率（P/S）=每股市价÷每股营业收入，反映投资者对公司销售收入的估值。'
        },
        {
            question: '企业确认股利支付率，应如何计算？',
            options: ['每股股利/每股收益', '每股收益/每股股利', '每股股利/每股市价', '每股市价/每股股利'],
            correctAnswer: 0,
            explanation: '股利支付率=每股股利÷每股收益，反映企业股利分配政策。'
        },
        {
            question: '企业确认股利收益率，应如何计算？',
            options: ['每股股利/每股市价', '每股市价/每股股利', '每股股利/每股收益', '每股收益/每股股利'],
            correctAnswer: 0,
            explanation: '股利收益率=每股股利÷每股市价，反映投资者从股利中获得的收益率。'
        },
        {
            question: '企业确认留存收益率，应如何计算？',
            options: ['(净利润-股利)/净利润', '股利/净利润', '净利润/股利', '股利/(净利润-股利)'],
            correctAnswer: 0,
            explanation: '留存收益率=(净利润-股利)÷净利润，反映企业将多少利润用于再投资。'
        },
        {
            question: '企业确认可持续增长率，应如何计算？',
            options: ['净资产收益率×留存收益率', '总资产收益率×留存收益率', '销售净利率×留存收益率', '资产周转率×留存收益率'],
            correctAnswer: 0,
            explanation: '可持续增长率=净资产收益率×留存收益率，反映企业在不增发新股的情况下可以实现的增长率。'
        },
        {
            question: '企业确认内部增长率，应如何计算？',
            options: ['(净资产收益率×留存收益率)/(1-净资产收益率×留存收益率)', '净资产收益率×留存收益率', '总资产收益率×留存收益率', '销售净利率×留存收益率'],
            correctAnswer: 0,
            explanation: '内部增长率=(净资产收益率×留存收益率)÷(1-净资产收益率×留存收益率)，反映企业在不增发新股、不增加负债的情况下可以实现的增长率。'
        },
        {
            question: '企业确认经济增加值（EVA），应如何计算？',
            options: ['税后净营业利润-资本成本', '净利润-资本成本', '利润总额-资本成本', '营业收入-资本成本'],
            correctAnswer: 0,
            explanation: '经济增加值（EVA）=税后净营业利润-资本成本，反映企业为股东创造的价值。'
        },
        {
            question: '企业确认市场增加值（MVA），应如何计算？',
            options: ['市场价值-投入资本', '投入资本-市场价值', '市场价值-账面价值', '账面价值-市场价值'],
            correctAnswer: 0,
            explanation: '市场增加值（MVA）=市场价值-投入资本，反映企业为股东创造的市场价值。'
        },
        {
            question: '企业确认杜邦分析体系，核心指标是？',
            options: ['净资产收益率', '总资产收益率', '销售净利率', '资产周转率'],
            correctAnswer: 0,
            explanation: '杜邦分析体系以净资产收益率（ROE）为核心，将其分解为销售净利率、资产周转率和权益乘数的乘积。'
        },
        {
            question: '企业确认现金流量表的主要目的是？',
            options: ['反映某一时点的财务状况', '反映某一时期的经营成果', '反映某一时期的现金流量', '反映某一时点的经营成果'],
            correctAnswer: 2,
            explanation: '现金流量表是反映企业在一定会计期间（时期）现金和现金等价物流入和流出的报表。'
        },
        {
            question: '企业确认经营活动产生的现金流量，主要包括？',
            options: ['销售商品、提供劳务收到的现金', '购建固定资产支付的现金', '取得投资收益收到的现金', '吸收投资收到的现金'],
            correctAnswer: 0,
            explanation: '经营活动产生的现金流量主要包括销售商品、提供劳务收到的现金，购买商品、接受劳务支付的现金等。'
        },
        {
            question: '企业确认投资活动产生的现金流量，主要包括？',
            options: ['销售商品收到的现金', '购建固定资产支付的现金', '支付职工工资的现金', '支付税款的现金'],
            correctAnswer: 1,
            explanation: '投资活动产生的现金流量主要包括购建固定资产、无形资产和其他长期资产支付的现金，以及收回投资收到的现金等。'
        },
        {
            question: '企业确认筹资活动产生的现金流量，主要包括？',
            options: ['销售商品收到的现金', '购建固定资产支付的现金', '吸收投资收到的现金', '支付职工工资的现金'],
            correctAnswer: 2,
            explanation: '筹资活动产生的现金流量主要包括吸收投资收到的现金、取得借款收到的现金，以及偿还债务支付的现金等。'
        },
        {
            question: '企业确认间接法编制现金流量表，起点是？',
            options: ['营业收入', '净利润', '经营活动产生的现金流量净额', '现金及现金等价物净增加额'],
            correctAnswer: 1,
            explanation: '间接法编制现金流量表时，以净利润为起点，调整不涉及现金的收入、费用、营业外收支以及经营性应收应付项目的变动。'
        },
        {
            question: '企业确认直接法编制现金流量表，起点是？',
            options: ['营业收入', '净利润', '经营活动产生的现金流量净额', '现金及现金等价物净增加额'],
            correctAnswer: 0,
            explanation: '直接法编制现金流量表时，以营业收入为起点，直接列示经营活动产生的各项现金流入和流出。'
        },
        {
            question: '企业确认现金等价物的特征，不包括？',
            options: ['期限短', '流动性强', '易于转换为已知金额的现金', '价值变动风险大'],
            correctAnswer: 3,
            explanation: '现金等价物是指企业持有的期限短、流动性强、易于转换为已知金额的现金、价值变动风险很小的投资。'
        },
        {
            question: '企业确认自由现金流量，应如何计算？',
            options: ['经营活动产生的现金流量净额-资本性支出', '净利润-资本性支出', '经营活动产生的现金流量净额-投资活动产生的现金流量净额', '净利润-经营活动产生的现金流量净额'],
            correctAnswer: 0,
            explanation: '自由现金流量=经营活动产生的现金流量净额-资本性支出，反映企业可以自由支配的现金流量。'
        },
        {
            question: '企业确认现金营运指数，应如何计算？',
            options: ['经营活动产生的现金流量净额/经营所得现金', '净利润/经营活动产生的现金流量净额', '经营所得现金/净利润', '经营活动产生的现金流量净额/净利润'],
            correctAnswer: 0,
            explanation: '现金营运指数=经营活动产生的现金流量净额÷经营所得现金，反映企业收益的质量。'
        },
        {
            question: '企业确认全部资产现金回收率，应如何计算？',
            options: ['经营活动产生的现金流量净额/资产总额', '经营活动产生的现金流量净额/平均资产总额', '净利润/平均资产总额', '营业收入/平均资产总额'],
            correctAnswer: 1,
            explanation: '全部资产现金回收率=经营活动产生的现金流量净额÷平均资产总额，反映企业资产产生现金的能力。'
        },
        {
            question: '企业确认销售现金比率，应如何计算？',
            options: ['经营活动产生的现金流量净额/营业收入', '净利润/营业收入', '营业收入/经营活动产生的现金流量净额', '经营活动产生的现金流量净额/净利润'],
            correctAnswer: 0,
            explanation: '销售现金比率=经营活动产生的现金流量净额÷营业收入，反映每元销售收入得到的现金流量净额。'
        },
        {
            question: '企业确认每股现金流量，应如何计算？',
            options: ['经营活动产生的现金流量净额/发行在外普通股加权平均数', '经营活动产生的现金流量净额/发行在外普通股总数', '现金及现金等价物净增加额/发行在外普通股加权平均数', '净利润/发行在外普通股加权平均数'],
            correctAnswer: 0,
            explanation: '每股现金流量=经营活动产生的现金流量净额÷发行在外普通股加权平均数，反映每股普通股获得的现金流量。'
        },
        {
            question: '企业确认现金回收期，应如何计算？',
            options: ['初始投资/年现金净流量', '年现金净流量/初始投资', '初始投资×年现金净流量', '年现金净流量-初始投资'],
            correctAnswer: 0,
            explanation: '现金回收期=初始投资÷年现金净流量，反映投资项目的资金回收速度，回收期越短说明项目风险越小。'
        }
    ];

    async aboutToAppear() {
        await this.loadProgress();
    }

    private async loadProgress(): Promise<void> {
        try {
            if (!this.prefs) {
                this.prefs = await preferences.getPreferences(this.context, 'quiz_progress');
            }
            const savedIndex: number = await this.prefs.get('currentQuestionIndex', 0) as number;
            const savedScore: number = await this.prefs.get('score', 0) as number;
            const savedAnswered: string = await this.prefs.get('answeredQuestions', '[]') as string;
            const savedSelected: number = await this.prefs.get('selectedAnswer', -1) as number;
            const savedShowResult: boolean = await this.prefs.get('showResult', false) as boolean;

            const parsedAnswered: number[] = JSON.parse(savedAnswered) as number[];

            if (savedIndex < this.questions.length) {
                this.currentQuestionIndex = savedIndex;
                this.score = savedScore;
                this.answeredQuestions = parsedAnswered;
                this.selectedAnswer = savedSelected;
                this.showResult = savedShowResult;
                this.checkQuizCompletion(savedIndex, savedShowResult, parsedAnswered);
            } else {
                this.currentQuestionIndex = this.questions.length;
                this.score = savedScore;
                this.answeredQuestions = parsedAnswered;
                this.selectedAnswer = -1;
                this.showResult = false;
                this.showCompletedDialog = true;
            }
        } catch (err) {
            console.error(`Failed to load quiz progress: ${JSON.stringify(err)}`);
        }
    }

    private async saveProgress(): Promise<void> {
        try {
            if (!this.prefs) {
                this.prefs = await preferences.getPreferences(this.context, 'quiz_progress');
            }
            await this.prefs.put('currentQuestionIndex', this.currentQuestionIndex);
            await this.prefs.put('score', this.score);
            await this.prefs.put('answeredQuestions', JSON.stringify(this.answeredQuestions));
            await this.prefs.put('selectedAnswer', this.selectedAnswer);
            await this.prefs.put('showResult', this.showResult);
            await this.prefs.flush();
        } catch (err) {
            console.error(`Failed to save quiz progress: ${JSON.stringify(err)}`);
        }
    }

    private async clearProgress(): Promise<void> {
        try {
            if (!this.prefs) {
                this.prefs = await preferences.getPreferences(this.context, 'quiz_progress');
            }
            await this.prefs.delete('currentQuestionIndex');
            await this.prefs.delete('score');
            await this.prefs.delete('answeredQuestions');
            await this.prefs.delete('selectedAnswer');
            await this.prefs.delete('showResult');
            await this.prefs.flush();
        } catch (err) {
            console.error(`Failed to clear quiz progress: ${JSON.stringify(err)}`);
        }
    }

    private handleAnswerSelect(index: number): void {
        if (this.showResult) {
            return;
        }
        this.selectedAnswer = index;
        this.saveProgress();
    }

    private submitAnswer(): void {
        if (this.selectedAnswer === -1) {
            return;
        }
        this.showResult = true;
        if (this.selectedAnswer === this.questions[this.currentQuestionIndex].correctAnswer) {
            this.score++;
        }
        if (!this.answeredQuestions.includes(this.currentQuestionIndex)) {
            this.answeredQuestions.push(this.currentQuestionIndex);
        }
        this.saveProgress();
    }

    private nextQuestion(): void {
        if (this.currentQuestionIndex < this.questions.length - 1) {
            this.currentQuestionIndex++;
            this.selectedAnswer = -1;
            this.showResult = false;
            this.saveProgress();
        }
    }

    private resetQuiz(): void {
        this.currentQuestionIndex = 0;
        this.selectedAnswer = -1;
        this.showResult = false;
        this.score = 0;
        this.answeredQuestions = [];
        this.showCompletedDialog = false;
        this.clearProgress();
    }

    private checkQuizCompletion(savedIndex: number, savedShowResult: boolean, answered: number[]): void {
        const totalCount: number = this.questions.length;
        const allAnswered: boolean = answered.length >= totalCount;
        const finishedLast: boolean = savedIndex >= totalCount - 1 && savedShowResult;
        if (allAnswered || finishedLast) {
            this.currentQuestionIndex = totalCount;
            this.selectedAnswer = -1;
            this.showResult = false;
            this.showCompletedDialog = true;
        }
    }

    build() {
        Navigation() {
            Scroll() {
                Column() {
                    if (this.currentQuestionIndex < this.questions.length) {
                        // 进度指示
                        Row() {
                            Text(`第 ${this.currentQuestionIndex + 1} 题 / 共 ${this.questions.length} 题`)
                                .fontSize(14)
                                .fontColor($r('app.color.text_tertiary'))
                            Blank()
                            Text(`得分: ${this.score}`)
                                .fontSize(14)
                                .fontColor($r('app.color.button_primary'))
                                .fontWeight(FontWeight.Medium)
                        }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 0, left: 16, right: 16 })

                        // 题目
                        Column() {
                            Text(this.questions[this.currentQuestionIndex].question)
                                .fontSize(16)
                                .fontWeight(FontWeight.Medium)
                                .fontColor($r('app.color.text_primary'))
                                .lineHeight(24)
                        }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16 })

                        // 选项
                        Column() {
                            ForEach(this.questions[this.currentQuestionIndex].options, (option: string, index: number) => {
                                Row() {
                                    Text(String.fromCharCode(65 + index))
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Medium)
                                        .fontColor(this.getOptionTextColor(index))
                                        .width(32)
                                        .height(32)
                                        .textAlign(TextAlign.Center)
                                        .borderRadius(16)
                                        .backgroundColor(this.getOptionBgColor(index))
                                    Text(option)
                                        .fontSize(15)
                                        .fontColor(this.getOptionTextColor(index))
                                        .margin({ left: 12 })
                                        .layoutWeight(1)
                                    if (this.showResult && index === this.questions[this.currentQuestionIndex].correctAnswer) {
                                        Text('✓')
                                            .fontSize(18)
                                            .fontColor($r('app.color.color_green'))
                                            .fontWeight(FontWeight.Bold)
                                    }
                                }
                                .width('100%')
                                .padding(16)
                                .backgroundColor(this.getOptionBgColor(index))
                                .borderRadius(8)
                                .margin({ bottom: 12 })
                                .onClick(() => {
                                    this.handleAnswerSelect(index);
                                })
                            })
                        }
                        .width('100%')
                        .padding(20)
                        .backgroundColor($r('app.color.bg_card'))
                        .margin({ top: 16, left: 16, right: 16 })

                        // 解析
                        if (this.showResult) {
                            Column() {
                                Row() {
                                    Text('解析')
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor($r('app.color.text_primary'))
                                }
                                .width('100%')
                                .margin({ bottom: 8 })
                                Text(this.questions[this.currentQuestionIndex].explanation)
                                    .fontSize(14)
                                    .fontColor($r('app.color.text_secondary'))
                                    .lineHeight(20)
                            }
                            .width('100%')
                            .padding(16)
                            .backgroundColor($r('app.color.bg_green_light'))
                            .borderRadius(12)
                            .margin({ top: 16, left: 16, right: 16 })
                        }

                        // 按钮
                        Button(this.showResult ? 
                            (this.currentQuestionIndex < this.questions.length - 1 ? '下一题' : '查看结果') : 
                            (this.selectedAnswer === -1 ? '请选择答案' : '提交答案'))
                            .type(ButtonType.Capsule)
                            .fontSize(16)
                            .fontWeight(FontWeight.Medium)
                            .backgroundColor(this.selectedAnswer === -1 && !this.showResult ? $r('app.color.gray_disabled') : $r('app.color.button_primary'))
                            .width('80%')
                            .constraintSize({ maxWidth: 320 })
                            .height(48)
                            .margin({ top: 16, left: 16, right: 16 })
                            .enabled(this.selectedAnswer !== -1 || this.showResult)
                            .onClick(() => {
                                if (this.showResult) {
                                    this.nextQuestion();
                                } else {
                                    this.submitAnswer();
                                }
                            })
                    } else {
                        // 完成页面
                        Column() {
                            Text('🎉')
                                .fontSize(64)
                                .margin({ top: 60, bottom: 20 })
                            Text('测验完成')
                                .fontSize(24)
                                .fontWeight(FontWeight.Bold)
                                .fontColor($r('app.color.text_primary'))
                                .margin({ bottom: 12 })
                            Text(`您答对了 ${this.score} 题，共 ${this.questions.length} 题`)
                                .fontSize(16)
                                .fontColor($r('app.color.text_tertiary'))
                                .margin({ bottom: 8 })
                            Text(`正确率: ${Math.round((this.score / this.questions.length) * 100)}%`)
                                .fontSize(16)
                                .fontColor($r('app.color.button_primary'))
                                .fontWeight(FontWeight.Medium)
                                .margin({ bottom: 40 })
                            Button('重新开始')
                                .type(ButtonType.Capsule)
                                .fontSize(16)
                                .fontWeight(FontWeight.Medium)
                                .backgroundColor($r('app.color.button_primary'))
                                .width('80%')
                                .constraintSize({ maxWidth: 320 })
                                .height(48)
                                .onClick(() => {
                                    this.resetQuiz();
                                })
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Center)
                        .alignItems(HorizontalAlign.Center)
                    }
                }
            }
            .scrollBar(BarState.Off)
            .edgeEffect(EdgeEffect.Spring)
            .backgroundColor($r('app.color.bg_page'))

            if (this.showCompletedDialog) {
                this.CompletedDialog();
            }
        }
        .title('小测验')
        .titleMode(NavigationTitleMode.Mini)
        .hideBackButton(false)
        .backgroundColor($r('app.color.bg_page'))
    }

    private getOptionBgColor(index: number): ResourceColor {
        if (!this.showResult) {
            return this.selectedAnswer === index ? $r('app.color.bg_blue_light') : $r('app.color.bg_card');
        }
        if (index === this.questions[this.currentQuestionIndex].correctAnswer) {
            return $r('app.color.bg_green_light');
        }
        if (index === this.selectedAnswer && index !== this.questions[this.currentQuestionIndex].correctAnswer) {
            return $r('app.color.bg_red_light');
        }
        return $r('app.color.bg_card');
    }

    private getOptionTextColor(index: number): ResourceColor {
        if (!this.showResult) {
            return this.selectedAnswer === index ? $r('app.color.button_primary') : $r('app.color.text_primary');
        }
        if (index === this.questions[this.currentQuestionIndex].correctAnswer) {
            return $r('app.color.color_green');
        }
        if (index === this.selectedAnswer && index !== this.questions[this.currentQuestionIndex].correctAnswer) {
            return $r('app.color.color_red_dark');
        }
        return $r('app.color.text_primary');
    }

    @Builder
    CompletedDialog() {
        Stack({ alignContent: Alignment.Center }) {
            Column()
                .width('100%')
                .height('100%')
                .backgroundColor('rgba(0, 0, 0, 0.5)')
                .onClick(() => {
                    this.showCompletedDialog = false;
                    router.back();
                })

            Column() {
                Text('全部题目已完成')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ bottom: 12 })
                Text('感谢参与小测验')
                    .fontSize(14)
                    .fontColor($r('app.color.text_secondary'))
                    .margin({ bottom: 20 })
                Button('好的')
                    .type(ButtonType.Capsule)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .backgroundColor($r('app.color.button_primary'))
                    .fontColor($r('app.color.white'))
                    .width('100%')
                    .height(44)
                    .onClick(() => {
                        this.showCompletedDialog = false;
                        router.back();
                    })
            }
            .width('78%')
            .constraintSize({ maxWidth: 320 })
            .padding({ left: 20, right: 20, top: 20, bottom: 20 })
            .backgroundColor($r('app.color.bg_card'))
            .borderRadius(16)
            .shadow({
                radius: 16,
                color: $r('app.color.shadow'),
                offsetX: 0,
                offsetY: 4
            })
        }
        .width('100%')
        .height('100%')
    }
}

