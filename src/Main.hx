import hxd.Key in K;

class WorldMesh extends h3d.scene.World {
  override function initChunkSoil(c: h3d.scene.World.WorldChunk) {
    var cube = new h3d.prim.Cube(chunkSize, chunkSize, 0);
    cube.addNormals();
    cube.addUVs();

    var soil = new h3d.scene.Mesh(cube, c.root);
    soil.x = c.x;
    soil.y = c.y;
    soil.material.texture = h3d.mat.Texture.fromColor(0x408020);
    soil.material.shadows = true;
  }

}

class Main extends hxd.App {
  var world : h3d.scene.World;
  var shadow :h3d.pass.DefaultShadowMap;
  var tf : h2d.Text;
  var player : h3d.scene.Object;

  static inline var PLAYER_SPEED = 10;

  override function init() {
    world = new WorldMesh(16, 256, s3d);

    var rockModel = world.loadModel(hxd.Res.rock);

    // add 300 rocks
    for(i in 0...300) {
      world.add(
        rockModel,
        Math.random() * 128,
        Math.random() * 128,
        0,
        1.2 + hxd.Math.srand(0.4),
        hxd.Math.srand(Math.PI)
      );
    }

    // add tree in middle, to move around like a character
    var cache = new h3d.prim.ModelCache();
    player = cache.loadModel(hxd.Res.tree);
    player.x = 64;
    player.y = 64;
    s3d.addChild(player);

    world.done();

    // add directional light
    new h3d.scene.fwd.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
    cast(s3d.lightSystem, h3d.scene.fwd.LightSystem).ambientLight.setColor(0x909090);

    // set camera
    s3d.camera.target.set(64, 64, 0);
    s3d.camera.pos.set(128, 128, 64);
    s3d.camera.zNear = 1;
    s3d.camera.zFar = 100;
    new h3d.scene.CameraController(s3d).loadFromCamera();

    // add debug text/HUD
    tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
  }

  override function update(dt: Float) {
    tf.text = 'player pos: [${player.x}, ${player.y}] drawCalls: ${engine.drawCalls}';

    // move player left/right
    if(hxd.Key.isDown(hxd.Key.LEFT) || hxd.Key.isDown(hxd.Key.A)) {
      player.x -= dt * PLAYER_SPEED;
    } else if (hxd.Key.isDown(hxd.Key.RIGHT) || hxd.Key.isDown(hxd.Key.D)) {
      player.x += dt * PLAYER_SPEED;
    }

    if(hxd.Key.isDown(hxd.Key.ESCAPE)) {
      hxd.System.exit();
    }
  }

  static function main() {
    hxd.Res.initEmbed();
    new Main();
  }
}
