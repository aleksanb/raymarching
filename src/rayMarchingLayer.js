/**
 * @constructor
 */
function rayMarchingLayer(layer) {
  this.config = layer.config;
  this.shaderPass = new THREE.ShaderPass(SHADERS.rayMarching);
}

rayMarchingLayer.prototype.getEffectComposerPass = function() {
  return this.shaderPass;
};

rayMarchingLayer.prototype.start = function() {
};

rayMarchingLayer.prototype.end = function() {
};

rayMarchingLayer.prototype.update = function(frame, relativeFrame) {
    this.shaderPass.uniforms.time.value = relativeFrame;
};

rayMarchingLayer.prototype.resize = function() {
};
