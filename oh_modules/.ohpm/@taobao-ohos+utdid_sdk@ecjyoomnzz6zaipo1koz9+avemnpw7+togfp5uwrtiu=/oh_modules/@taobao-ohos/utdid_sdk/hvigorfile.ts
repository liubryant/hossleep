// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
// module.exports = require('@ohos/hvigor-ohos-plugin').hspTasks
// export { harTasks } from '@ohos/hvigor-ohos-plugin';
import { harTasks } from '@ohos/hvigor-ohos-plugin';
import {tcpkg_dependencies, mtl_plugin} from '@ali/tcpkg'

export default {
  system: harTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins:[tcpkg_dependencies(), mtl_plugin()]         /* Custom plugin to extend the functionality of Hvigor. */
}