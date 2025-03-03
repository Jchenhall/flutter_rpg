import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/skill.dart';
import 'package:flutter_rpg/models/stats.dart';
import 'package:flutter_rpg/models/vocation.dart';

class Character with Stats {

  //constructor
  Character({
    required this.vocation,
    required this.name, 
    required this.slogan, 
    required this.id
    });

  //fields
  final Set<Skill> skills ={};
  final Vocation vocation;
  final String name;
  final String slogan;
  final String id;
  bool _isFav = false;

  //getters
  bool get isFav => _isFav;


  void toggleIsFav() {
    _isFav = !_isFav;
  }

  void updateSkill(Skill skill){
    skills.clear();
    skills.add(skill);
  }

//character to firestore (map)
Map<String, dynamic> toFirestore(){
return {
  'name': name,
  'slogan': slogan,
  'isFav': _isFav,
  'vocation': vocation.toString(),
  'skills': skills.map((skill) => skill.id).toList(),
  'stats': statsAsMap,
  'points': points,
};
}

//character from firestore
factory Character.fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> snapshot,
  SnapshotOptions? options ) {
  
final data = snapshot.data()!;

//make character instance
Character character = Character(
  name: data['name'],
  slogan: data['slogan'],
  id: snapshot.id,
  vocation: Vocation.values.firstWhere((v) => v.toString() == data['vocation']),
);

//Update skills
for (String id in data['skills']){
  Skill skill = allSkills.firstWhere((element) => element.id == id);
  character.updateSkill(skill);
}

//is fav
if(data['isFav'] == true){
  character.toggleIsFav();
}

//assignn stats & points
character.setStats(
  points: data['points'],
  stats: data['stats'],
);

return character;
}

}



