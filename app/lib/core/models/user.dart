class StrideUser {
  String id;
  //int birth_year;
  //bool hasSize;
  bool profile_flag;
  List shoulder;
  List bust;
  List waist;
  List hip;
  List thigh;

  StrideUser(
      {this.id,
      this.profile_flag,
      this.shoulder,
      this.bust,
      this.waist,
      this.hip,
      this.thigh});

  StrideUser.clone(StrideUser user)
      : this(
          id: user.id,
          //birth_year: user.birth_year,
          profile_flag: user.profile_flag,
          shoulder: user.shoulder,
          waist: user.waist,
          bust: user.bust,
          hip: user.hip,
          thigh: user.thigh,
        );
}
