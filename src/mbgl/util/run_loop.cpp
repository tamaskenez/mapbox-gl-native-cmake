#include <mbgl/util/run_loop.hpp>

namespace mbgl {
namespace util {

uv::tls<RunLoop> RunLoop::current;

RunLoop::RunLoop(uv_loop_t* loop)
    : async(loop, std::bind(&RunLoop::process, this)) {
    current.set(this);
}

RunLoop::~RunLoop() {
    current.set(nullptr);
}

void RunLoop::withMutex(std::function<void()>&& fn) {
    std::lock_guard<std::mutex> lock(mutex);
    fn();
}

void RunLoop::process() {
    Queue queue_;

#ifdef _MSC_VER
    // there's some bug in VS2015RC with passing 'this' into the closure
    // remove this workaround as soon as it gets fixed
    Queue* this_queue = &this->queue;
    withMutex([&,this_queue] { queue_.swap(*this_queue); });
#else
    withMutex([&] { queue_.swap(queue); });
#endif

    while (!queue_.empty()) {
        (*(queue_.front()))();
        queue_.pop();
    }
}

void RunLoop::stop() {
    invoke([&] { async.unref(); });
}

}
}
