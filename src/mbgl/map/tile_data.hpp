#ifndef MBGL_MAP_TILE_DATA
#define MBGL_MAP_TILE_DATA

#include <mbgl/util/noncopyable.hpp>
#include <mbgl/map/tile_id.hpp>
#include <mbgl/renderer/debug_bucket.hpp>
#include <mbgl/geometry/debug_font_buffer.hpp>

#include <atomic>
#include <string>
#include <functional>

namespace mbgl {

class StyleLayer;
class Worker;

class TileData : private util::noncopyable {
public:
    enum class State {
        invalid,
        initial,
        loading,
        loaded,
        partial,
        parsed,
        obsolete
    };

    // Tile data considered "Ready" can be used for rendering. Data in
    // partial state is still waiting for network resources but can also
    // be rendered, although layers will be missing.
    inline static bool isReadyState(const State& state) {
        return state == State::partial || state == State::parsed;
    }

    TileData(const TileID&);
    virtual ~TileData() = default;

    virtual void request(Worker&,
                         float pixelRatio,
                         const std::function<void()>& callback) = 0;

    // Schedule a tile reparse on a worker thread and call the callback on
    // completion. It will return true if the work was schedule or false it was
    // not, which can occur if the tile is already being parsed by another
    // worker.
    virtual bool reparse(Worker&,
                         std::function<void ()> callback) = 0;

    // Mark this tile as no longer needed and cancel any pending work.
    virtual void cancel() = 0;

    virtual Bucket* getBucket(const StyleLayer&) = 0;

    virtual void redoPlacement(float, bool) {}

    bool isReady() const {
        return isReadyState(state);
    }

    State getState() const {
        return state;
    }

    std::string getError() const {
        return error;
    }

    const TileID id;

    // Contains the tile ID string for painting debug information.
    DebugBucket debugBucket;
    DebugFontBuffer debugFontBuffer;

protected:
    std::atomic<State> state;
    std::string error;
};

}

#endif
