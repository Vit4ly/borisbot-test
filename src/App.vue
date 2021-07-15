<template>
  <div class="add">
    <button class="add__btn" @click="addElement">New Element</button>
  </div>
  <div
      class="square"
      v-for="({ id, x, y }, idx) in elements"
      :key="id"
      :style="{ top: y + 'px', left: x + 'px' }"
      draggable="true"
      @dragstart="handleDragstart($event, idx, id)"
      @dragend="handleDragend"
      @dblclick="deleteElem($event, idx, id)"
      @click="onConnect($event, idx, id)"
  ></div>
  <canvas
      id="canvas"
      @drop="onDrop($event)"
      @dragover.prevent
      @dragenter.prevent
  ></canvas>
</template>

<script>
export default {
  name: "App",
  mounted() {
    const canvas = document.getElementById("canvas");
    this.ctx = canvas.getContext("2d");
    this.width = canvas.width = innerWidth;
    this.height = canvas.height = innerHeight;
    this.vueCanvas = this.ctx;

    for (let n = 0; n < 5; n++) {
      this.addElement();
    }
  },

  data() {
    return {
      ctx: null,
      width: null,
      height: null,
      dragItemId: null,
      size: 50,
      vueCanvas: null,
      elements: [],
      connectId: [],
      connectElements: [],
    };
  },
  methods: {
    deleteElem(e, idx, id) {
      this.connectId = this.connectId.filter((el) => el !== id);
      this.connectElements = this.connectElements.filter((el) => el.id !== id);
      this.elements.splice(idx, 1);
      this.updateConnect(this.connectElements);
    },
    randomId(num) {
      return Math.round(Math.random() * num).toString();
    },

    addElement() {
      this.elements.push({
        id: this.randomId(10000),
        x: Math.random() * (this.width - this.size),
        y: Math.random() * (this.height - this.size),
        connect: 0,
      });
    },

    handleDragstart(e, idx, id) {
      e.target.classList.add("hold");
      setTimeout(() => e.target.classList.add("hide"), 0);
      this.dragItemId = id;
      const item = this.elements.find((el) => el.id === this.dragItemId);
      e.dataTransfer.dropEffect = "move";
      e.dataTransfer.effectAllowed = "move";
      e.dataTransfer.setData("itemID", item.id);
    },

    handleDragend(e) {
      e.target.classList.remove("hold");
      e.target.classList.remove("hide");
      this.dragItemId = null;
    },

    onDrop(e) {
      const itemID = e.dataTransfer.getData("itemID");
      const item = this.elements.find((el) => el.id === itemID);
      const idx = this.elements.indexOf(item);
      this.elements[idx].x = e.clientX;
      this.elements[idx].y = e.clientY;
      this.updateConnect(this.connectElements);
    },

    onConnect(e, idx, id) {
      this.ctx.clearRect(0, 0, this.width, this.height);
      e.target.classList.toggle("connect");

      if (this.connectId.includes(id)) {
        this.connectElements = this.connectElements.filter(
            (el) => el.id !== id
        );
        this.connectId = this.connectId.filter((el) => el !== id);
      } else {
        this.connectId.push(this.elements[idx].id);
        this.elements[idx].connect = this.elements[idx].id;
        this.connectElements.push(this.elements[idx]);
      }

      const connectElemLength = this.connectId.length;

      if (connectElemLength > 1) {
        this.elements[idx].connect = this.connectId[0];
        const filterElements = this.elements.filter(
            (el) => el.connect === this.connectId[0]
        );

        for (let i = 0; i < filterElements.length - 1; i += 1)
          this.drawLine(
              filterElements[i].x,
              filterElements[i + 1].x,
              filterElements[i].y,
              filterElements[i + 1].y
          );
      }
      this.updateConnect(this.connectElements);
    },

    updateConnect(elements) {
      this.ctx.clearRect(0, 0, this.width, this.height);
      for (let i = 0; i < elements.length - 1; i+=1) {
        this.drawLine(
            elements[i].x,
            elements[i + 1].x,
            elements[i].y,
            elements[i + 1].y
        );
      }
    },

    drawLine(x1, x2, y1, y2) {
      this.ctx.beginPath();
      this.ctx.moveTo(x1 + this.size / 2, y1 + this.size / 2);
      this.ctx.lineTo(x2 + this.size / 2, y2 + this.size / 2);
      this.ctx.stroke();
    },
  }
};
</script>

<style scoped lang="scss">
html,
body {
  margin: 0;
}

canvas {
  display: block;
}

.square {
  position: absolute;
  width: 50px;
  height: 50px;
  border: 1px solid rgba(0, 0, 0, 0.2);
  background-color: #fff;
}

.hold {
  border: 1px solid rgb(46, 149, 202);
  box-shadow: 0 5px 10px 2px rgba(99, 183, 241, 0.2);
  transition: all 0.3s;
}

.hide {
  display: none;
}

.add {
  position: absolute;
  top: 2%;
  left: 50vw;

  &__btn {
    font-weight: 500;
    padding: 10px;
    border-radius: 10px;
    color: #fff;
    background-color: rgb(53, 197, 253);
    transition: background-color 0.3s;

    &:hover {
      background-color: rgb(5, 178, 245);
    }
  }
}

.connect {
  box-shadow: 0 5px 10px 2px rgba(99, 183, 241, 0.8);
}
</style>
