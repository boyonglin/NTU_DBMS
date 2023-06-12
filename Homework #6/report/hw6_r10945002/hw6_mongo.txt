// TASK 1
use("hw6");
db.students.find({ 學號: "R10945002" });

// TASK 2
db.students.find({ 系所: "生醫電資所" });

// TASK 3
db.students.aggregate([
  {
    $group: {
      _id: { 系所: "$系所", 年級: "$年級" },
      count: { $sum: 1 },
    },
  },
  { $sort : { "_id.系所": -1, "_id.年級": 1 } },
]);

// TASK 4
db.students.updateMany({}, { $set: { join_date: "2023-03-01" } });
db.students.find({ 系所: "生醫電資所" });

// TASK 5
db.students.deleteMany({ 姓名: { $in: ["小紅", "小黃", "小綠"] } });
db.students.insertMany([
  {
    身份: "旁聽生",
    系所: "電機所",
    年級: 2,
    學號: "R10123456",
    姓名: "小紅",
    信箱: "r10123456@ntu.edu.tw",
    join_date: "2023-06-02",
  },
  {
    身份: "學生",
    系所: "物理系",
    年級: 3,
    學號: "B09987653",
    姓名: "小黃",
    信箱: "b09987653@ntu.edu.tw",
    join_date: "2023-06-02",
  },
  {
    身份: "觀察者",
    系所: "電信所",
    年級: 1,
    學號: "R11123001",
    姓名: "小綠",
    信箱: "r11123001@ntu.edu.tw",
    join_date: "2023-06-02",
  },
]);
db.students.find({
  $or: [{ 學號: "R10945002" }, { join_date: "2023-06-02" }],
});

// TASK 6
db.tally.drop();
var queryDate = "2023-06-10";
var updateSessionStats = function (queryDate) {
  db.students.aggregate([
    {
      $match: {
        join_date: { $lt: queryDate },
      },
    },
    {
      $group: {
        _id: { 系所: "$系所", 年級: "$年級" },
        count: { $sum: 1 },
      },
    },
    {
      $project: {
        value: {
          count: "$count",
        },
      },
    },
    {
      $merge: {
        into: "tally",
        whenMatched: [
          {
            $set: {
              "value.count": { $add: ["$value.count", "$$new.value.count"] },
            },
          },
        ],
        whenNotMatched: "insert",
      },
    },
  ]);
};
updateSessionStats(queryDate);
db.tally.find({ "_id.系所": { $in: ["電機所", "物理系", "電信所"] } });